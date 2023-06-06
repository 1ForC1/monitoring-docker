let users = [];
var audioInfo = new Audio('/audio/info.mp3');
var audioWarning = new Audio('/audio/warning.mp3');

async function loadUsers() {
    if (getCookie("MonitoringCookieToken") !== "") {
        if (accessCheck('CanDeleteUsers')) {
            await requestSample(null, 'api/users', 'GET', getCookie("MonitoringCookieToken"))
                .then(function () {
                    document.getElementById("tbody").innerHTML = ''
                    if (response.data !== null) {
                        users = response.data
                    }
                    let htmlinput = ``;
                    for (let i = 0; i < users.length; i++) {
                        htmlinput += `<tr>
        <td><label class="toggler-wrapper style-22">
                    <input id="checkbox${i}" type="checkbox">
                    <div class="toggler-slider">
                        <div class="toggler-knob"></div>
                    </div>
                </label></td>
        <td><input style="text-align: center; color: #FFFFFF;background-color: transparent;border-color: transparent;" id="surname${i}" value="${users[i].surname}"
        maxlength="50" required pattern="[а-яА-Яa-zA-Z]{1,50}" title="от 1 до 50 латиница, кириллица, цифры" type="text" placeholder="Фамилия..."></td>
        <td><input style="text-align: center; color: #FFFFFF;background-color: transparent;border-color: transparent;" id="name${i}" value="${users[i].name}"
        maxlength="50" required pattern="[а-яА-Яa-zA-Z]{1,50}" title="от 1 до 50 латиница, кириллица, цифры" type="text" placeholder="Имя..."></td>
        <td><input style="text-align: center; color: #FFFFFF;background-color: transparent;border-color: transparent;" id="patronymic${i}" value="${users[i].patronymic}"
        maxlength="50" required pattern="[а-яА-Яa-zA-Z]{1,50}" title="от 1 до 50 латиница, кириллица, цифры" type="text" placeholder="Отчество..."></td>
        <td><p style="font-weight: bold" id="login${i}">${users[i].login}</p></td>
        <td><input style="text-align: center; color: #FFFFFF;background-color: transparent;border-color: transparent;" id="password${i}" value=""
        maxlength="50" pattern="[a-zA-Z0-9]{1,50}" placeholder="Пароль..."></td>
        <td><label class="toggler-wrapper style-22">`;

                        if (users[i].CanDeleteUsers) {
                            htmlinput += `<input id="CanDeleteUsers${i}" checked="checked" type="checkbox">`
                        } else {
                            htmlinput += `<input id="CanDeleteUsers${i}" type="checkbox">`
                        }
                        htmlinput += `<div class="toggler-slider">
                         <div class="toggler-knob"></div></div></label></td>
                        <td><label class="toggler-wrapper style-22">`;

                        if (users[i].CanViewHosts) {
                            htmlinput += `<input id="CanViewHosts${i}" checked="checked" type="checkbox">`
                        } else {
                            htmlinput += `<input id="CanViewHosts${i}" type="checkbox">`
                        }
                        htmlinput += `<div class="toggler-slider">
                         <div class="toggler-knob"></div></div></label></td>
                        <td><label class="toggler-wrapper style-22">`;

                        if (users[i].CanViewLog) {
                            htmlinput += `<input id="CanViewLog${i}" checked="checked" type="checkbox">`
                        } else {
                            htmlinput += `<input id="CanViewLog${i}" type="checkbox">`
                        }
                        htmlinput += `<div class="toggler-slider">
                         <div class="toggler-knob"></div></div></label></td></tr>`;
                    }
                    htmlinput += `<tr>
                    <td><button type="button" class="btn btn-secondary text-white me-2"  style="margin-bottom: 5px" onclick="insertUsers();">Добавить</button></td>
        <td><input style="text-align: center; color: #FFFFFF;background-color: transparent;border-color: transparent;" id="surnameInsert"
        maxlength="50" pattern="[а-яА-Яa-zA-Z]{1,50}" title="от 1 до 50 латиница, кириллица, цифры" type="text" placeholder="Фамилия..."></td>
        <td><input style="text-align: center; color: #FFFFFF;background-color: transparent;border-color: transparent;" id="nameInsert"
        maxlength="50" pattern="[а-яА-Яa-zA-Z]{1,50}" title="от 1 до 50 латиница, кириллица, цифры" type="text" placeholder="Имя..."></td>
        <td><input style="text-align: center; color: #FFFFFF;background-color: transparent;border-color: transparent;" id="patronymicInsert"
        maxlength="50" pattern="[а-яА-Яa-zA-Z]{1,50}" title="от 1 до 50 латиница, кириллица, цифры" type="text" placeholder="Отчество..."></td>
        <td><input style="text-align: center; color: #FFFFFF;background-color: transparent;border-color: transparent;" id="loginInsert"
        maxlength="50" pattern="[a-zA-Z0-9]{1,50}" placeholder="login..."></td>
        <td><input style="text-align: center; color: #FFFFFF;background-color: transparent;border-color: transparent;" id="passwordInsert"
        maxlength="50" pattern="[a-zA-Z0-9]{1,50}" placeholder="Пароль..."></td>
                    <td></td>   
                    <td></td>   
                    <td></td>             
                    </tr>`;
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

async function deleteUsers() {
    if (getCookie("MonitoringCookieToken") !== "") {
        if (accessCheck('CanDeleteUsers')) {
            for (let i = 0; i < users.length; i++) {
                let checkbox = document.getElementById('checkbox' + i);
                if (checkbox.checked) {
                    let login = document.getElementById('login' + i).innerHTML
                    if (login !== getCookie("MonitoringCookieLogin")) {
                        let body = JSON.stringify({login: login})
                        await requestSample(body, 'api/delete-user', 'DELETE', getCookie("MonitoringCookieToken")).then(function () {
                            if (response.data != null) {
                                new Toast({
                                    title: false,
                                    text: 'Успешное удаление пользователя ' + login + ' (' + status + ')',
                                    theme: 'secondary',
                                    autohide: true,
                                    interval: 5000
                                });
                                audioInfo.play();
                                loadUsers();
                            } else {
                                new Toast({
                                    title: false,
                                    text: 'Произошла ошибка при удалении пользователя ' + login + ' (' + status + ')',
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
                            text: 'Это ваш аккаунт, вы не можете его удалить.',
                            theme: 'secondary',
                            autohide: true,
                            interval: 5000
                        });
                        audioInfo.play();
                    }
                }
            }
        }
    } else {
        alert("Вы не авторизировались!");
        window.location.href = "auth";
    }
}

async function updateUsers() {
    if (getCookie("MonitoringCookieToken") !== "") {
        if (accessCheck('CanDeleteUsers')) {
            for (let i = 0; i < users.length; i++) {
                let checkbox = document.getElementById('checkbox' + i);
                if (checkbox.checked) {
                    let surname = document.getElementById('surname' + i).value
                    let name = document.getElementById('name' + i).value
                    let patronymic = document.getElementById('patronymic' + i).value
                    let password = document.getElementById('password' + i).value
                    let login = document.getElementById('login' + i).innerHTML
                    let CanDeleteUsers = document.getElementById('CanDeleteUsers' + i).checked
                    let CanViewHosts = document.getElementById('CanViewHosts' + i).checked
                    let CanViewLog = document.getElementById('CanViewLog' + i).checked
                    if (login !== getCookie("MonitoringCookieLogin")) {
                        if (password === undefined || password === null) {
                            password = "";
                        }
                        if (surname !== "" && name !== "" && patronymic !== "" && login !== "" &&
                            CanDeleteUsers !== null && CanDeleteUsers !== undefined &&
                            CanViewHosts !== null && CanViewHosts !== undefined &&
                            CanViewLog !== null && CanViewLog !== undefined) {
                            let body = JSON.stringify({
                                surname: surname,
                                name: name,
                                patronymic: patronymic,
                                login: login,
                                password: password,
                                CanDeleteUsers: CanDeleteUsers,
                                CanViewHosts: CanViewHosts,
                                CanViewLog: CanViewLog
                            })
                            await requestSample(body, 'api/update-user', 'POST', getCookie("MonitoringCookieToken")).then(function () {
                                if (response.data != null) {
                                    new Toast({
                                        title: false,
                                        text: 'Успешное изменение пользователя ' + login + ' (' + status + ')',
                                        theme: 'secondary',
                                        autohide: true,
                                        interval: 5000
                                    });
                                    audioInfo.play();
                                    loadUsers();
                                } else {
                                    new Toast({
                                        title: false,
                                        text: 'Произошла ошибка при изменении пользователя ' + login + ' (' + status + ')',
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
                        new Toast({
                            title: false,
                            text: 'Это ваш аккаунт, вы не можете его изменить.',
                            theme: 'secondary',
                            autohide: true,
                            interval: 5000
                        });
                        audioInfo.play();
                    }
                }
            }
        }
    } else {
        alert("Вы не авторизировались!");
        window.location.href = "auth";
    }
}

async function insertUsers() {
    if (getCookie("MonitoringCookieToken") !== "") {
        if (accessCheck('CanDeleteUsers')) {
            let surname = document.getElementById('surnameInsert').value
            let name = document.getElementById('nameInsert').value
            let patronymic = document.getElementById('patronymicInsert').value
            let password = document.getElementById('passwordInsert').value
            let login = document.getElementById('loginInsert').value
            if (surname !== "" && name !== "" && patronymic !== "" && login !== "" && password !== "") {
                let body = JSON.stringify({
                    surname: surname,
                    name: name,
                    patronymic: patronymic,
                    login: login,
                    password: password
                })
                await requestSample(body, 'auth/sign-up', 'POST', getCookie("MonitoringCookieToken")).then(function () {
                    if (response.id != null) {
                        new Toast({
                            title: false,
                            text: 'Успешное добавление пользователя ' + login + ' (' + status + ')',
                            theme: 'secondary',
                            autohide: true,
                            interval: 5000
                        });
                        audioInfo.play();
                        loadUsers();
                    } else {
                        new Toast({
                            title: false,
                            text: 'Произошла ошибка при добавлении пользователя ' + login + ' (' + status + ')',
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
        }
    } else {
        alert("Вы не авторизировались!");
        window.location.href = "auth";
    }
}

async function reloadUsers() {
    window.setInterval(loadUsers, 30000000);
}