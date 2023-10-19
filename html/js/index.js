window.addEventListener('message', event => {
    let item = event.data
    let data = item.data
    if (item.type !== "menu") return

    if (item.action === "open") {
        $('.menu').css({
            display: "flex"
        })

        $('.title').text(data.title)
        $('.header').css({
            "background-color": data.color
        })

        $('.buttons').empty()

        let index = 0
        data.buttons.forEach(element => {
            index += 1

            $(`<div id="${index.toString()}" class="button">${element}</div>`)
                .appendTo('.buttons')
        })

        $(`.menu .button:first-child`).css({
            "color": 'black',
            'background-color': 'white'
        })
    }

    if (item.action === "close") {
        $('.menu').css({
            display: 'none'
        })
    }

    if (item.action === "update") {
        $('.buttons .button').each(function(index, element) {
            $(element).css({
                "color": '#ffffff',
                "background-color": "transparent",
                "margin-top": '7px',
            })
        })

        $('.buttons #' + data.index.toString()).css({
            "color": 'black',
            'background-color': 'white',
        })
    }
})