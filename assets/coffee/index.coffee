$ ->

    # Sample answers
    # Standardise answer to be always array regardless of the number of answers
    master =
        "1": [["apple", "boy"]]
        "2": ["apple", "boy", ["cat", "dog"]]

    checkAnswer = (data) ->
        dfd = $.Deferred()

        # Mocking AJAX and PHP
        answers = master[data.id]

        response =
            state: true

        response.state = false if answers.length isnt data.answers.length

        response.result = []

        for answer, i in answers
            r = {}

            r.state = true

            if $.isArray answer
                r.state = false if data.answers[i] not in answer
            else
                r.state = false if answer isnt data.answers[i]

            if r.state is false
                response.state = false
                r.answer = answer

            response.result.push r

        dfd.resolve response

        return dfd

    items = $ ".item[data-type=fill]"

    $.each items, (i, item) ->
        item = $ item
        question = item.find ".question"

        question.html question.html().replace /\{input\}/g, '<input type="text" class="form-control input" />'

    items.on "click", ".check", (event) ->
        button = $ @
        block = $ event.delegateTarget
        block.trigger "check"

    items.on "check", (event) ->
        block = $ @
        id = block.data "id"

        inputs = block.find ".input"
        inputs.removeClass "correct wrong"

        inputs.prop "disabled", true

        answers = ($(input).val() for input in inputs)

        checkAnswer(
            id: id
            answers: answers
        ).done (response) ->
            # (bool) response.state True if overall correct
            # (array) response.result
            # response.result = [{
            #   state: (bool) individual state
            #   answer: (optional, string/array) answers
            # }]

            if response.state is true
                inputs.addClass "correct"
            else
                for r, i in response.result
                    input = $ inputs[i]

                    input.addClass if r.state then "correct" else "wrong"