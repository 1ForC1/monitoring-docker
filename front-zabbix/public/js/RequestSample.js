let response

async function requestSample(body, url, method, token) {
    return new Promise(resolve => {
        fetch(url, {
            method: method,
            mode: "cors",
            body: body,
            headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer ' + token
            }
        }).then(res => res.json())
            .then(data => {
                console.log(data)
                response = data
                resolve();
            })
            .catch(error => {
                console.log(error)
            })
    })
}