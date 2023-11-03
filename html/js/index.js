window.addEventListener('message', event => {
    let item = event.data
    let data = item.data
    if (item.type !== "menu") return

    if (item.action === "open") {
        $('.menu').css({ // make menu visible
            display: "flex"
        })

        $('.menu .header .title').text(data.title) // update title on menu

        $('.buttons').empty()

        let index = 0
        data.buttons.forEach(element => {
            index += 1

            $(`<div id="${index.toString()}" class="button"><p>${element}<p></div>`)
                .appendTo('.buttons') // Add buttons to menu
        })

        $(`.menu .button:first-child`).css({ // make the first button primary
            "color": 'black',
            'background-color': 'white'
        })
    }

    if (item.action === "close") { // close menu
        $('.menu').css({
            display: 'none'
        })
    }

    if (item.action === "update") {
        $('.buttons .button').each(function(index, element) {
            $(element).css({ // reset all buttons
                "color": 'white',
                "background-color": "rgba(255, 255, 255, 0.063)",
                "margin-top": '7px',
            })
        })

        $('.buttons #' + data.index.toString()).css({ // make button primary
            "color": 'black',
            'background-color': 'white',
        })
    }

    if (item.action === "updateButton") {
        $('.buttons #' + data.index.toString() + ' .p').text(data.text)
    }
})

$(document).ready(() => {
    $('.cancel').click(() => {
        removePrompt()
        sendCallback('Prompt:Result', {
            result: false
        })
    })

    $('.submit').click(() => {
        sendCallback('Prompt:Result', {
            result: true,
            text: $('.prompt .input').val()
        })

        removePrompt()
    })
})

window.addEventListener('message', event => {
    let item = event.data
    let data = item.data
    if (item.type !== "prompt") return

    $('.prompt').show()
    $('.prompt .title').text(data.text)
    $('.prompt .input').css({
        "font-size": data.size
    }).focus()
})

window.addEventListener('message', event => {
    let item = event.data
    let data = item.data
    if (item.type !== "copy") return

    const element = document.createElement('textarea');
    element.value = data.text;
    document.body.appendChild(element);

    element.select();
    
    document.execCommand('copy');
    document.body.removeChild(element);
})