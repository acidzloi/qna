App.cable.subscriptions.create('QuestionsChannel', {
  connected: ->
    @perform 'follow'

  received: (data) ->
    question = JSON.parse(data)
    $(".questions").append("<p><a href='/questions/#{question["id"]}'>#{question["title"]}</a></p>")
})
