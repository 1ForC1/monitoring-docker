var audioInfo = new Audio('/audio/info.mp3');
var audioWarning = new Audio('/audio/warning.mp3');

async function auth() {
    let login = document.getElementById('loginAuth').value
    let password = document.getElementById('passwordAuth').value
    if (login !== "" && password !== "") {
        await authRequest(login, password)
    } else {
        new Toast({
            title: false,
            text: 'Не все поля заполнены',
            theme: 'secondary',
            autohide: true,
            interval: 5000
        });
        audioInfo.play();
    }
}

async function authRequest(login, password) {
    let body = JSON.stringify({login: login, password: password})
    await requestSample(body, 'auth/sign-in', 'POST', null).then(function () {
        if (response.token !== undefined) {
            document.cookie = encodeURIComponent('MonitoringCookieToken') + '=' + encodeURIComponent(response.token);
            document.cookie = encodeURIComponent('MonitoringCookieLogin') + '=' + encodeURIComponent(login);
            window.location.href = "profile";
        } else {
            new Toast({
                title: false,
                text: 'Пароль или логин неверный (' + status + ')',
                theme: 'warning',
                autohide: true,
                interval: 5000
            });
            audioWarning.play();
        }
    }).catch(function () {
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

//Функция регистрации
async function reg() {
    let login = document.getElementById('loginReg').value
    let password = document.getElementById('passwordReg').value
    let name = document.getElementById('NameReg').value
    let surname = document.getElementById('SurnameReg').value
    let patronymic = document.getElementById('PatronymicReg').value
    if (login !== "" && password !== "" && name !== "" && surname !== "" && patronymic !== "") {
        //Запись тела
        let body = JSON.stringify({
            surname: surname,
            name: name,
            patronymic: patronymic,
            login: login,
            password: password
        })
        //Отправка запроса на сервер
        await requestSample(body, 'auth/sign-up', 'POST', null).then(function () {
            if (response.id != null) {
                authRequest(login, password)
            } else {
                new Toast({
                    title: false,
                    text: 'Неправильно заполнены поля или такой пользователь уже существует (' + status + ')',
                    theme: 'warning',
                    autohide: true,
                    interval: 5000
                });
                audioWarning.play();
            }
        }).catch()
    } else {
        new Toast({
            title: false,
            text: 'Не все поля заполнены',
            theme: 'secondary',
            autohide: true,
            interval: 5000
        });
        audioInfo.play();
    }
}