let logs = [];
var audioInfo = new Audio('/audio/info.mp3');
var audioWarning = new Audio('/audio/warning.mp3');

async function loadLog() {
    if (getCookie("MonitoringCookieToken") !== "") {
        if (accessCheck('CanViewLog')) {
            await requestSample(null, 'api/triggers', 'GET', getCookie("MonitoringCookieToken"))
                .then(function () {
                    document.getElementById("tbody").innerHTML = ''
                    if (response.data !== null) {
                        logs = response.data
                    }
                    let htmlinput = ``;
                    for (let i = 0; i < logs.length; i++) {
                        htmlinput += `<tr style="cursor: pointer" onclick="
document.cookie = encodeURIComponent('MonitoringCookieHostCheckID') + '=' + encodeURIComponent(${logs[i].id_host});
document.cookie = encodeURIComponent('MonitoringCookieHostCheckPriority') + '=' + encodeURIComponent(${logs[i].priority.String});
window.location.href = 'main';
getIdHost(${logs[i].id_host}, ${logs[i].priority.String});">
        <td>${Date().toLocaleString()}</td>
        <td>${logs[i].triggerid}</td>
        <td>${logs[i].description.String}</td>
        <td>${logs[i].triggers_expression.String}</td>`;
                        let color = "#4abe51";
                        let priorityText = "Низкий";
                        if (Number(logs[i].priority.String) >= 1 && Number(logs[i].priority.String) < 3) {
                            color = "#FF8C42"
                            priorityText = "Средний"
                        } else if (Number(logs[i].priority.String) >= 3) {
                            color = "#D62828"
                            priorityText = "Высокий"
                        }
                        htmlinput += `<td style="background-color: ` + color + `; font-weight: bold">` + priorityText + `</td>
        <td>` + logs[i].id_host + `</td>
        </tr>`;
                    }
                    document.getElementById('tbody').insertAdjacentHTML('beforeend', htmlinput);
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

async function reloadLogs() {
    window.setInterval(loadLog, 30000)
}