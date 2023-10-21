window.addEventListener('message', event => {
    let item = event.data
    let data = item.data
    if (item.type !== "menu") return

    if (item.action === "open") {
        $('.menu').css({ // make menu visible
            display: "flex"
        })

        $('.title').text(data.title) // update title on menu
        $('.header').css({ // update background color on header
            "background-color": data.color
        })

        $('.buttons').empty()

        let index = 0
        data.buttons.forEach(element => {
            index += 1

            $(`<div id="${index.toString()}" class="button">${element}</div>`)
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
                "color": '#ffffff',
                "background-color": "transparent",
                "margin-top": '7px',
            })
        })

        $('.buttons #' + data.index.toString()).css({ // make button primary
            "color": 'black',
            'background-color': 'white',
        })
    }
})