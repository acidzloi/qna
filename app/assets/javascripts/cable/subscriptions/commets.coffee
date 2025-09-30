App.cable.subscriptions.create({ channel: 'CommentsChannel', question_id: gon.question_id }, {
  connected: ->
    @perform 'follow'

  received: (data) ->
    parseData = JSON.parse(data)
    commentData = { comment: parseData.comment, body: parseData.comment.body, user_email: parseData.user_email }
    divClass = '.' + parseData.comment.commenteble_type.toLowerCase()

    if gon.current_user && (gon.current_user.id != parseData.comment.user_id)
       $(divClass + ' .comments').append(JST['templates/comment'](commentData))
})
