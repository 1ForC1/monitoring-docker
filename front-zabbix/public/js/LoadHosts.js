let hosts = [];
let triggers = [];
let hostInfo = [];
let colorPriority = "#4abe51";
var audioInfo = new Audio('/audio/info.mp3');
var audioWarning = new Audio('/audio/warning.mp3');

async function reload() {
    if (getCookie("MonitoringCookieToken") !== "") {
        if (accessCheck('CanViewHosts')) {
            await requestSample(null, 'api/hosts', 'GET', getCookie("MonitoringCookieToken"))
                .then(function () {
                    if (response.data !== null) {
                        hosts = response.data
                        requestSample(null, 'api/triggers', 'GET', getCookie("MonitoringCookieToken"))
                            .then(function () {
                                document.getElementsByClassName("grid")[0].innerHTML = ''
                                if (response.data !== null) {
                                    triggers = response.data
                                }

                                let priority = 0;
                                colorPriority = "#4abe51";
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
                                        colorPriority = "#FF8C42"
                                    }
                                    if (priority >= 3) {
                                        colorPriority = "#D62828"
                                    }

                                    let htmlinput = `<div class="hostDiv" style="background-color: ` + colorPriority + `; cursor: pointer; " id="` + hosts[i].id_host + `" onclick="getIdHost(this.id, ` + priority + `)">
                                <p style="color: black;text-align: center; font-weight: bold; font-size: 19px; word-break: break-all;">` + hosts[i].host_name.String + `</p>
                                <img class="imageHost" src="/images/computer.png" alt="ПК"/>
                                <p style="color: black;text-align: center; margin-top: 15px; font-weight: bold; font-size: 15px; overflow-wrap: break-all;">` + hosts[i].host_interfaces + `</p>
                                </div>`;

                                    document.getElementsByClassName('grid')[0].insertAdjacentHTML('beforeend', htmlinput);
                                    priority = 0;
                                    colorPriority = "#4abe51";
                                }
                            }).catch(function () {
                            if (status === 401) {
                                alert("Вы не авторизировались!");
                                window.location.href = "auth";
                            }
                            new Toast({
                                title: false,
                                text: 'Произошла ошибка (' + status + ')',
                                theme: 'warning',
                                autohide: true,
                                interval: 5000
                            });
                            audioWarning.play();
                        })
                    }
                }).catch(function () {
                    if (status === 401) {
                        alert("Вы не авторизировались!");
                        window.location.href = "auth";
                    }
                    new Toast({
                        title: false,
                        text: 'Произошла ошибка (' + status + ')',
                        theme: 'warning',
                        autohide: true,
                        interval: 5000
                    });
                    audioWarning.play();
                })
        }
    } else {
        alert("Вы не авторизировались!");
        window.location.href = "auth";
    }
}

async function loadHosts() {
    window.setInterval(reload, 3000)
}

function getIdHost(id, priority) {
    if (getCookie("MonitoringCookieToken") !== "") {
        let body = JSON.stringify({hostid: Number(id)})

        requestSample(body, 'api/host-info', 'POST', getCookie("MonitoringCookieToken"))
            .then(function () {
                document.getElementById("hostInfo").innerHTML = ''
                if (response.data !== null) {
                    hostInfo = response.data
                }

                if (Number(priority) >= 1 && Number(priority) < 3) {
                    colorPriority = "#FF8C42"
                } else if (Number(priority) >= 3) {
                    colorPriority = "#D62828"
                } else {
                    colorPriority = "#4abe51";
                }
                let htmlinput = `<table id="myTable" class="table">
            <tr style="background-color: ` + colorPriority + `;">
            <td colspan="3">            <h2 style="color: #FFFFFF; text-align: center;">` + hostInfo.host_name + `</h2></td>
            </tr>
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
        <td>` + (Number(hostInfo.value_size_free.String) / 1024 / 1024 / 1024).toFixed(2) + ` ГБ</td>
        <td>` + hostInfo.time_size_free.String + `</td>
        </tr>
        <tr>
        <td>Объём диска</td>
        <td>` + (Number(hostInfo.value_size_total.String) / 1024 / 1024 / 1024).toFixed(2) + ` ГБ</td>
        <td>` + hostInfo.time_size_total.String + `</td>
        </tr>
        <tr>
        <td>Доступно ОЗУ</td>
        <td>` + (Number(hostInfo.value_memory_available.String) / 1024 / 1024 / 1024).toFixed(2) + ` ГБ</td>
        <td>` + hostInfo.time_memory_available.String + `</td>
        </tr>
        <tr>
        <td>Объём ОЗУ</td>
        <td>` + (Number(hostInfo.value_memory_total.String) / 1024 / 1024 / 1024).toFixed(2) + ` ГБ</td>
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
        <td>` + hostInfo.value_cpu_steal.String + ` %</td>
        <td>` + hostInfo.time_cpu_steal.String + `</td>
        </tr>
        <tr>
        <td>Нагрузка на ЦПУ softirq</td>
        <td>` + hostInfo.value_cpu_softirq.String + ` %</td>
        <td>` + hostInfo.time_cpu_softirq.String + `</td>
        </tr>
        <tr>
        <td>Нагрузка на ЦПУ nice</td>
        <td>` + hostInfo.value_cpu_nice.String + ` %</td>
        <td>` + hostInfo.time_cpu_nice.String + `</td>
        </tr>
        <tr>
        <td>Нагрузка на ЦПУ interrupt</td>
        <td>` + hostInfo.value_cpu_interrupt.String + ` %</td>
        <td>` + hostInfo.time_cpu_interrupt.String + `</td>
        </tr>
        <tr>
        <td>Нагрузка на ЦПУ iowait</td>
        <td>` + hostInfo.value_cpu_iowait.String + ` %</td>
        <td>` + hostInfo.time_cpu_iowait.String + `</td>
        </tr>
	        </tbody>
        </table>`;

                document.getElementById('hostInfo').insertAdjacentHTML('beforeend', htmlinput);
                document.cookie = encodeURIComponent('MonitoringCookieHostCheckID') + '=' + encodeURIComponent(id);
                document.cookie = encodeURIComponent('MonitoringCookieHostCheckPriority') + '=' + encodeURIComponent(priority);
            }).catch(function () {
            if (status === 401) {
                alert("Вы не авторизировались!");
                window.location.href = "auth";
            }
            new Toast({
                title: false,
                text: 'Произошла ошибка (' + status + ')',
                theme: 'warning',
                autohide: true,
                interval: 5000
            });
            audioWarning.play();
        })
    } else {
        alert("Вы не авторизировались!");
        window.location.href = "auth";
    }
}