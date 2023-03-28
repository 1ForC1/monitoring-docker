async function auth() {
    let login = document.getElementById('loginAuth').value
    let password = document.getElementById('passwordAuth').value
    let body = JSON.stringify({login: login, password: password})
    let response = await requestSample(body, 'http://127.0.0.1:3210/auth/sign-in', 'POST', null)
    let expires = new Date();
    expires.setHours(expires.getHours() + 4);
    document.cookie = encodeURIComponent('token')+'='+encodeURIComponent(response.token);
    document.location.href = "main";
}