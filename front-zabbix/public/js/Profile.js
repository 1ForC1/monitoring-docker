var audioInfo = new Audio('/audio/info.mp3');
var audioWarning = new Audio('/audio/warning.mp3');
let user = [];

async function getProfile() {
    if (getCookie("MonitoringCookieToken") !== "" && getCookie("MonitoringCookieLogin") !== "") {
        let login = getCookie("MonitoringCookieLogin")
        let body = JSON.stringify({login: login})
        await requestSample(body, 'api/profile', 'POST', getCookie("MonitoringCookieToken")).then(function () {
            if (response.data !== null) {
                user = response.data;
                document.getElementById("profileData").innerHTML = ''
                let htmlinput = `<div style="display: flex;align-items: center;justify-content: center;
    flex-direction: column;padding: 0 50px;height: 100%;text-align: center;">
            Фамилия
            <input style="color: #FFFFFF;background-color: #6c757d;border-radius: 10px; border-color: transparent;padding: 12px 15px;margin: 8px 0;width: 35%;" id="Surname" maxlength="50" required pattern="[а-яА-Яa-zA-Z]{1,50}"
                   title="от 1 до 50 латиница, кириллица, цифры" value="` + response.data.surname + `" type="text" placeholder="Фамилия..."/>
            Имя
            <input style="color: #FFFFFF;background-color: #6c757d;border-radius: 10px; border-color: transparent;padding: 12px 15px;margin: 8px 0;width: 35%;" id="Name" maxlength="50" required pattern="[а-яА-Яa-zA-Z0-9]{1,50}"
                   title="от 1 до 50 латиница, кириллица, цифры" value="` + response.data.name + `" type="text" placeholder="Имя..."/>
            Отчество
            <input style="color: #FFFFFF;background-color: #6c757d;border-radius: 10px; border-color: transparent;padding: 12px 15px;margin: 8px 0;width: 35%;" id="Patronymic" maxlength="50" required pattern="[а-яА-Яa-zA-Z0-9]{1,50}"
                   title="от 1 до 50 латиница, кириллица, цифры" value="` + response.data.patronymic + `" type="text" placeholder="Отчество..."/>
            Пароль
            <input style="color: #FFFFFF;background-color: #6c757d;border-radius: 10px; border-color: transparent;padding: 12px 15px;margin: 8px 0;width: 35%;" id="password" maxlength="50" required pattern="[a-zA-Z0-9]{1,50}"
                   title="от 1 до 50 латиница, цифры" type="password" placeholder="Пароль..."/>
            <button type="button" onclick="UpdateProfile();" class="btn btn-secondary text-white me-2">Изменить профиль</button></div>`;
                document.getElementById('profileData').insertAdjacentHTML('beforeend', htmlinput);
            } else {
                alert("Неверный логин!");
                window.location.href = "auth";
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
    } else {
        alert("Вы не авторизировались!");
        window.location.href = "auth";
    }
}

async function UpdateProfile() {
    if (getCookie("MonitoringCookieToken") !== "" && getCookie("MonitoringCookieLogin") !== "") {
        let password = document.getElementById('password').value
        let name = document.getElementById('Name').value
        let surname = document.getElementById('Surname').value
        let patronymic = document.getElementById('Patronymic').value
        let login = getCookie("MonitoringCookieLogin")
        if (login !== "" && name !== "" && surname !== "" && patronymic !== "") {
            //Запись тела
            let body = JSON.stringify({
                surname: surname,
                name: name,
                patronymic: patronymic,
                login: login,
                password: password,
                CanDeleteUsers: user.CanDeleteUsers,
                CanViewHosts: user.CanViewHosts,
                CanViewLog: user.CanViewLog
            })
            //Отправка запроса на сервер
            await requestSample(body, 'api/update-user', 'POST', getCookie("MonitoringCookieToken")).then(function () {
                if (response.data != null) {
                    new Toast({
                        title: false,
                        text: 'Успешное изменение данных профиля (' + status + ')',
                        theme: 'secondary',
                        autohide: true,
                        interval: 5000
                    });
                    audioInfo.play();
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
            new Toast({
                title: false,
                text: 'Не все поля заполнены',
                theme: 'secondary',
                autohide: true,
                interval: 5000
            });
            audioInfo.play();
        }
    } else {
        alert("Вы не авторизировались!");
        window.location.href = "auth";
    }
}

async function reloadProfile() {
    window.setInterval(getProfile, 30000000);
}