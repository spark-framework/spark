async function sendCallback(url, data) {
    return (
        await fetch(`https://${GetParentResourceName()}/${url}`, {
            method: "POST",
            headers: {
                "Content-Type": 'application/json; charset=UTF-8'
            },
            body: JSON.stringify(data)
        })
    ).json()
}

function removePrompt() {
    $('.prompt').hide()
    $('.prompt .input').val('')
}