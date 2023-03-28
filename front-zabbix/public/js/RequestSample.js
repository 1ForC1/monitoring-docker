async function requestSample(body, url, method) {
    let response
    await fetch(url, {
        method: method,
        mode: "cors",
        body: body,
        headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2Nzk0MjA0MDAsImlhdCI6MTY3OTM3NzIwMCwidXNlcl9pZCI6MX0.CJ0zv3puQm9yJF_b6MPXP6jmIBX0xK-I-ElE-nKBrDQ'
        }
    }).then(res => res.json())
        .then(data => {
            console.log(data)
            response = data
        })
        .catch(error => {
            console.log(error)
        })
    return response
}