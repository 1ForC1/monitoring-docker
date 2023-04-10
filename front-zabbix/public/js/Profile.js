async function getProfile() {
    let login = getCookie("MonitoringCookieLogin")
    let body = JSON.stringify({login: login})
    await requestSample(body, 'http://127.0.0.1:3210/api/profile', 'POST', getCookie("MonitoringCookieToken")).then(function () {
        if (response.data !== null) {
            document.getElementById("profileData").innerHTML = ''
            let htmlinput = `<p style="text-align: center">Логин: `+response.data.login+`</p>
            <p style="text-align: center">Фамилия: `+response.data.surname+`</p>
            <p style="text-align: center">Имя: `+response.data.name+`</p>
            <p style="text-align: center">Отчество: `+response.data.patronymic+`</p>`;
            document.getElementById('profileData').insertAdjacentHTML('beforeend', htmlinput);

        } else {
            alert("Пароль или логин не верный!");
            //Обработка ошибки auth
        }
    })
}