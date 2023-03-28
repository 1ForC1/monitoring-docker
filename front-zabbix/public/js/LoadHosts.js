async function loadHosts (){
    let response = await requestSample(null, 'http://127.0.0.1:3210/api/hosts', 'GET')
    console.log('123'+response)
}