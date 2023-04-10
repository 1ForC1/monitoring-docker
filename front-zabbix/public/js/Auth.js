async function auth() {
    let login = document.getElementById('loginAuth').value
    let password = document.getElementById('passwordAuth').value
    let body = JSON.stringify({login: login, password: password})
    await requestSample(body, 'http://127.0.0.1:3210/auth/sign-in', 'POST', null).then(function () {
        if (response.token !== undefined) {
            document.cookie = encodeURIComponent('MonitoringCookieToken') + '=' + encodeURIComponent(response.token);
            document.cookie = encodeURIComponent('MonitoringCookieLogin') + '=' + encodeURIComponent(login);
            document.location.href = "main";
        } else {
            alert("Пароль или логин не верный!");
            //Обработка ошибки auth
        }
    })
}

async function reg() {
    let login = document.getElementById('loginReg').value
    let password = document.getElementById('passwordReg').value
    let name = document.getElementById('NameReg').value
    let surname = document.getElementById('SurnameReg').value
    let patronymic = document.getElementById('PatronymicReg').value
    let body = JSON.stringify({surname: surname, name: name, patronymic: patronymic, login: login, password: password})
    await requestSample(body, 'http://127.0.0.1:3210/auth/sign-up', 'POST', null).then(function () {
        if (response.data.id != null) {
            if (response.token !== undefined) {
                document.cookie = encodeURIComponent('MonitoringCookieToken') + '=' + encodeURIComponent(response.token);
                document.location.href = "main";
            } else {
                alert("Данные заполнены неверно!");
                //Обработка ошибки reg
            }
        } else {
            alert("Произошла ошибка!");
            //Обработка ошибки reg
        }

    }).catch(function () {
        alert("Произошла ошибка!");
    })
}