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
            color = "#FF8C42"
        }
        if (priority >= 3) {
            color = "#D62828"
        }

        let htmlinput = `<div class="hostDiv" style="background-color: ` + color + `;" id="` + searchedHosts[i].id_host + `" onclick="getIdHost(this.id)">
                                <p style="color: black;text-align: center; font-weight: bold; font-size: 19px; word-break: break-all;">` + searchedHosts[i].host_name.String + `</p>
                                <img class="imageHost" src="/images/computer.png"/>
                                <p style="color: black;text-align: center; margin-top: 15px; font-weight: bold; font-size: 15px; overflow-wrap: break-all;">` + searchedHosts[i].host_interfaces + `</p>
                                </div>`;

        document.getElementsByClassName('grid')[0].insertAdjacentHTML('beforeend', htmlinput);
        priority = 0;
        color = "#4abe51";
    }
}
