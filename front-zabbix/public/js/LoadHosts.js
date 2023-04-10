let hosts = [];
let triggers = [];
let hostInfo = [];

async function reload() {
    if (getCookie("MonitoringCookieToken") !== "") {
        await requestSample(null, 'http://127.0.0.1:3210/api/hosts', 'GET', getCookie("MonitoringCookieToken"))
            .then(function () {
                if (response.data !== null) {
                    hosts = response.data
                    requestSample(null, 'http://127.0.0.1:3210/api/triggers', 'GET', getCookie("MonitoringCookieToken"))
                        .then(function () {
                            document.getElementsByClassName("grid")[0].innerHTML = ''
                            if (response.data !== null) {
                                triggers = response.data
                            }

                            let priority = 0;
                            let color = "#4abe51";
                            if (document.getElementById("searchInput").value !== undefined && document.getElementById("searchInput").value !== null
                                && document.getElementById("searchInput").value !== "") {
                                //hosts = hosts.filter(h => h.host_name.String.indexOf(document.getElementById("searchInput").value) >= 0);
                                return search(document.getElementById("searchInput").value)
                            }
                            for (let i = 0; i < hosts.length; i++) {

                                let triggered = triggers.filter(item => item.id_host === hosts[i].id_host)
                                for (let j = 0; j < triggered.length; j++) {
                                    if (Number(triggered[j].priority.String) > priority)
                                        priority = Number(triggered[j].priority.String);
                                }
                                if (priority >= 1 && priority < 3) {
                                    color = "#EEFC57"
                                }
                                if (priority >= 3) {
                                    color = "#D62828"
                                }

                                let htmlinput = `<div style="background-color: ` + color + `;" id="` + hosts[i].id_host + `" onclick="getIdHost(this.id)">
                                <p style="color: black;text-align: center; font-weight: bold; font-size: 19px; word-break: break-all;">` + hosts[i].host_name.String + `</p>
                                <img class="imageHost" src="/images/computer.png" style="height: 80px; width: 80px"/>
                                <p style="color: black;text-align: center; margin-top: 15px; font-weight: bold; font-size: 15px; overflow-wrap: break-all;">` + hosts[i].host_interfaces + `</p>
                                </div>`;

                                document.getElementsByClassName('grid')[0].insertAdjacentHTML('beforeend', htmlinput);
                                priority = 0;
                                color = "#4abe51";
                            }
                        })
                }
            })
    } else {
        alert("Вы не авторизировались!");
        document.location.href = "auth";
    }
}

async function loadHosts() {
    window.setInterval(reload, 300000)
}

function getIdHost(id) {
    if (getCookie("MonitoringCookieToken") !== "") {
        let body = JSON.stringify({hostid: Number(id)})
        requestSample(body, 'http://127.0.0.1:3210/api/host-info', 'POST', getCookie("MonitoringCookieToken"))
            .then(function () {
                document.getElementById("hostInfo").innerHTML = ''
                if (response.data !== null) {
                    hostInfo = response.data
                }
                let htmlinput = `<table class="table">
        	<thead>
		        <tr>
			        <th>Наименование</th>
			        <th>Значение</th>
			        <th>Время</th>
		        </tr>
	        </thead>
	        <tbody>
		        <tr>
			        <td>Среднее количество процессов за 1 мин</td>
			        <td>` + hostInfo.value_percpu_avg1.String + ` шт</td>
			        <td>` + hostInfo.time_percpu_avg1.String + `</td>
		        </tr>
		        <tr>
        <td>Среднее количество процессов за 5 мин</td>
        <td>` + hostInfo.value_percpu_avg5.String + ` шт</td>
        <td>` + hostInfo.time_percpu_avg5.String + `</td>
        </tr>
        <tr>
        <td>Среднее количество процессов за 15 мин</td>
        <td>` + hostInfo.value_percpu_avg15.String + ` шт</td>
        <td>` + hostInfo.time_percpu_avg15.String + `</td>
        </tr>
        <tr>
        <td>Свободное место на диске</td>
        <td>` + (Number(hostInfo.value_size_free.String)/1024/1024/1024).toFixed(2) + ` ГБ</td>
        <td>` + hostInfo.time_size_free.String + `</td>
        </tr>
        <tr>
        <td>Объём диска</td>
        <td>` + (Number(hostInfo.value_size_total.String)/1024/1024/1024).toFixed(2) + ` ГБ</td>
        <td>` + hostInfo.time_size_total.String + `</td>
        </tr>
        <tr>
        <td>Доступно ОЗУ</td>
        <td>` + (Number(hostInfo.value_memory_available.String)/1024/1024/1024).toFixed(2) + ` ГБ</td>
        <td>` + hostInfo.time_memory_available.String + `</td>
        </tr>
        <tr>
        <td>Объём ОЗУ</td>
        <td>` + (Number(hostInfo.value_memory_total.String)/1024/1024/1024).toFixed(2) + ` ГБ</td>
        <td>` + hostInfo.time_memory_total.String + `</td>
        </tr>
        <tr>
        <td>Нагрузка на ЦПУ idle</td>
        <td>` + hostInfo.value_cpu_util_idle.String + ` %</td>
        <td>` + hostInfo.time_cpu_util_idle.String + `</td>
        </tr>
        <tr>
        <td>Нагрузка на ЦПУ user</td>
        <td>` + hostInfo.value_cpu_util_user.String + ` %</td>
        <td>` + hostInfo.time_cpu_util_user.String + `</td>
        </tr>
        <tr>
        <td>Нагрузка на ЦПУ system</td>
        <td>` + hostInfo.value_cpu_system.String + ` %</td>
        <td>` + hostInfo.time_cpu_system.String + `</td>
        </tr>
        <tr>
        <td>Нагрузка на ЦПУ steal</td>
        <td>`+hostInfo.value_cpu_steal.String+` %</td>
        <td>`+hostInfo.time_cpu_steal.String+`</td>
        </tr>
        <tr>
        <td>Нагрузка на ЦПУ softirq</td>
        <td>`+hostInfo.value_cpu_softirq.String+` %</td>
        <td>`+hostInfo.time_cpu_softirq.String+`</td>
        </tr>
        <tr>
        <td>Нагрузка на ЦПУ nice</td>
        <td>`+hostInfo.value_cpu_nice.String+` %</td>
        <td>`+hostInfo.time_cpu_nice.String+`</td>
        </tr>
        <tr>
        <td>Нагрузка на ЦПУ interrupt</td>
        <td>`+hostInfo.value_cpu_interrupt.String+` %</td>
        <td>`+hostInfo.time_cpu_interrupt.String+`</td>
        </tr>
        <tr>
        <td>Нагрузка на ЦПУ iowait</td>
        <td>`+hostInfo.value_cpu_iowait.String+` %</td>
        <td>`+hostInfo.time_cpu_iowait.String+`</td>
        </tr>
	        </tbody>
        </table>`;

                document.getElementById('hostInfo').insertAdjacentHTML('beforeend', htmlinput);

            })
    } else {
        alert("Вы не авторизировались!");
        document.location.href = "auth";
    }
}
