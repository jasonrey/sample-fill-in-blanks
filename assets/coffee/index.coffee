$ ->
    # Sample answers
    # Standardise answer to be always array regardless of the number of answers
    master =
        "1": ["apple"]

    verifyAnswer = (data) ->
        answers = master[data.id]

        console.log master, answers, data

        return false if answers.length isnt data.answers.length

        i = answers.length

        while i--
            return false if answers[i] isnt data.answers[i]

        return true
    checkAnswer = (data) ->
        response =
            result: verifyAnswer data

        if response.result is false
            response.answers = master[data.id]

        return response

    item = $ ".item"

    item.on "click", ".check", (event) ->
        button = $ @
        block = $ event.delegateTarget
        block.trigger "check"

    item.on "check", (event) ->
        block = $ @
        id = block.data "id"

        inputs = block.find ".input"

        inputs.prop "disabled", true

        answers = ($(input).val() for input in inputs)

        data = checkAnswer(
            id: id
            answers: answers
        )

        # (bool) data.result True for correct
        # (array) data.answers

        if data.result is true
            inputs.addClass "correct"
        else
            for a, i in data.answers
                input = $ inputs[i]

                input.addClass if a is input.val() then "correct" else "wrong"