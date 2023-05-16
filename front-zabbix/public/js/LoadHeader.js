var audioInfo = new Audio('/audio/info.mp3');
var audioWarning = new Audio('/audio/warning.mp3');

function loadHeader(search, page) {
    const header = document.getElementById('header')
    header.innerHTML = `
  <div class="px-3 text-white" style="border-bottom-left-radius: 10px; border-bottom-right-radius: 10px; background: #4D5061;padding-top: 1.75rem!important;padding-bottom: 0.5rem!important;">
    <div class="container">
      <div class="d-flex flex-wrap align-items-center justify-content-center justify-content-lg-start">
        <a class="d-flex align-items-center my-2 my-lg-0 me-lg-auto text-white text-decoration-none">
            <img src="/images/security-camera.svg" width="50px" height="50px" style="margin-right: 5px; margin-top: -20px"/>
            <h4>Система мониторинга состояния технических средств</h4>
        </a>

        <ul class="nav col-12 col-lg-auto my-2 justify-content-center my-md-0 text-small">
          <li>
            <a id="main" href="main" class="nav-link text-black">
              Главная
            </a>
          </li>
          <li>
            <a id="profile" href="profile" class="nav-link text-black">
              Профиль
            </a>
          </li>
          <li>
            <a id="log" href="log" class="nav-link text-black">
              Журнал событий
            </a>
          </li>
          <li>
            <a id="users" href="users" class="nav-link text-black">
              Пользователи
            </a>
          </li>
        </ul>
      </div>
    </div>
  </div>
`
    //Search
    if (search) {
        header.innerHTML += `  <div class="px-3 py-2 border-bottom mb-3">
    <div class="container d-flex flex-wrap" style="justify-content: space-between">
          <input style="width: auto;background-color: #6c757d; color: #FFFFFF" class="col-12 col-lg-auto mb-lg-0 form-control" type="search" id="searchInput" oninput="search(this.value)" placeholder="Поиск...">
          <button type="button" class="btn btn-secondary text-white me-2" onclick="reload();">Обновить</button>
          <button type="button" class="btn btn-secondary text-white me-2" id="download-pdf">Сохранить в PDF</button>

      <div class="text-end">
        <button type="button" class="btn btn-secondary text-white me-2" onclick="exit();">Выход</button>
      </div>
    </div>
  </div>`;
    } else {
        header.innerHTML += `  <div class="px-3 py-2 border-bottom mb-3">
    <div class="container flex-wrap justify-content-center">
      <div class="text-end">
        <button type="button" class="btn btn-secondary text-white me-2" onclick="exit();">Выход</button>
      </div>
    </div>
  </div>`;
    }
    if (page === "main") {
        textUrl = document.getElementById('main')
    } else if (page === "profile") {
        textUrl = document.getElementById('profile')
    } else if (page === "log") {
        textUrl = document.getElementById('log')
    } else if (page === "users") {
        textUrl = document.getElementById('users')
    } else {
        textUrl = document.getElementById('main')
    }
    textUrl.setAttribute('class', 'nav-link text-white')
}

function exit() {
    document.cookie = encodeURIComponent('MonitoringCookieToken') + '=';
    document.cookie = encodeURIComponent('MonitoringCookieLogin') + '=';
    document.cookie = encodeURIComponent('MonitoringCookieHostCheckID') + '=';
    document.cookie = encodeURIComponent('MonitoringCookieHostCheckPriority') + '=';
    window.location.href = 'auth';
}

async function accessCheck(access) {
    if (getCookie("MonitoringCookieToken") !== "" && getCookie("MonitoringCookieLogin") !== "") {
        let login = getCookie("MonitoringCookieLogin")
        let body = JSON.stringify({login: login})
        await requestSample(body, 'api/profile', 'POST', getCookie("MonitoringCookieToken")).then(function () {
                if (response.data !== null) {
                    if (access === "CanViewHosts" && response.data.CanViewHosts) {
                        return true
                    } else if (access === "CanDeleteUsers" && response.data.CanDeleteUsers) {
                        return true
                    } else if (access === "CanViewLog" && response.data.CanViewLog) {
                        return true
                    } else {
                        alert("У вас нет доступа к данной странице, обратитесь к администратору!");
                        window.location.href = "profile";
                        return false
                    }
                }
            }
        ).catch(function () {
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
    return false
}