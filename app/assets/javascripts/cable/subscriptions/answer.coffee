App.cable.subscriptions.create({ channel: 'AnswersChannel', question_id: gon.question_id }, {
  connected: ->
    @perform 'follow'

  received: (data) ->
    parseData = $.parseJSON(data)

    if gon.current_user && (gon.current_user.id != parseData.answer.user_id)
      $('.answers').append(JST['templates/answer']({
        answer: parseData.answer,
        files: parseData.files,
        links: parseData.links,
        total_votes: parseData.total_votes
      }))
})
