let response
let status
var audioInfo = new Audio('/audio/info.mp3');
var audioWarning = new Audio('/audio/warning.mp3');

async function requestSample(body, url, method, token) {
    return await new Promise(resolve => {
        fetch('http://127.0.0.1:3210/'+url, {
            method: method,
            mode: "cors",
            body: body,
            headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer ' + token
            }
        }).then(res => res.json().then(data => ({status: res.status, body: data})))
            .then(data => {
                //console.log(data)
                status = data.status
                response = data.body
                resolve();
            })
            .catch(error => {
                if (status === 401) {
                    alert("Вы не авторизировались!");
                    window.location.href = "auth";
                }
                new Toast({
                    title: false,
                    text: 'Произошла ошибка (' + error.message + ')',
                    theme: 'danger',
                    autohide: true,
                    interval: 5000
                });
                audioWarning.play();
            })
    })
}