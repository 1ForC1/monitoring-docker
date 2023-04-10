function loadHeader() {
    const header = document.getElementById('header')
    header.innerHTML = `
  <div class="px-3 py-2 text-white" style="background: #4D5061">
    <div class="container">
      <div class="d-flex flex-wrap align-items-center justify-content-center justify-content-lg-start">
        <a class="d-flex align-items-center my-2 my-lg-0 me-lg-auto text-white text-decoration-none">
            <img src="/images/security-camera.svg" width="50px" height="50px" style="margin-right: 5px; margin-top: -20px"/>
            <h4>Система мониторинга состояния технических средств</h4>
        </a>

        <ul class="nav col-12 col-lg-auto my-2 justify-content-center my-md-0 text-small">
          <li>
            <a href="main" class="nav-link text-black">
              <svg class="bi d-block mx-auto mb-1" width="24" height="24"><use xlink:href="#home"></use></svg>
              Главная
            </a>
          </li>
          <li>
            <a href="profile" class="nav-link text-white">
              <svg class="bi d-block mx-auto mb-1" width="24" height="24"><use xlink:href="#speedometer2"></use></svg>
              Профиль
            </a>
          </li>
          <li>
            <a href="#" class="nav-link text-white">
              <svg class="bi d-block mx-auto mb-1" width="24" height="24"><use xlink:href="#speedometer2"></use></svg>
              Журнал событий
            </a>
          </li>
          <li>
            <a href="#" class="nav-link text-white">
              <svg class="bi d-block mx-auto mb-1" width="24" height="24"><use xlink:href="#speedometer2"></use></svg>
              Пользователи
            </a>
          </li>
        </ul>
      </div>
    </div>
  </div>
  <div class="px-3 py-2 border-bottom mb-3">
    <div class="container d-flex flex-wrap justify-content-center">
      <form class="col-12 col-lg-auto mb-2 mb-lg-0 me-lg-auto">
        <input type="search" id="searchInput" oninput="search(this.value)" class="form-control" placeholder="Поиск..." aria-label="Search">
      </form>

      <div class="text-end">
        <button type="button" class="btn btn-light text-dark me-2" onclick="document.location.href = 'auth'">Выход</button>
      </div>
    </div>
  </div>
`
}

function search(input) {
    var searchedHosts = hosts.filter(h => h.host_name.String.indexOf(input) >= 0);
    document.getElementsByClassName("grid")[0].innerHTML = ''

    let priority = 0;
    let color = "#4abe51";

    for (let i = 0; i < searchedHosts.length; i++) {

        let triggered = triggers.filter(item => item.id_host === searchedHosts[i].id_host)
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

        let htmlinput = `<div style="background-color: ` + color + `;" id="` + searchedHosts[i].id_host + `" onclick="getIdHost(this.id)">
                                <p style="color: black;text-align: center; font-weight: bold; font-size: 19px; word-break: break-all;">` + searchedHosts[i].host_name.String + `</p>
                                <img class="imageHost" src="/images/computer.png" style="height: 80px; width: 80px"/>
                                <p style="color: black;text-align: center; margin-top: 15px; font-weight: bold; font-size: 15px; overflow-wrap: break-all;">` + searchedHosts[i].host_interfaces + `</p>
                                </div>`;

        document.getElementsByClassName('grid')[0].insertAdjacentHTML('beforeend', htmlinput);
        priority = 0;
        color = "#4abe51";
    }
}
