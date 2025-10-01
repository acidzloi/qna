$(document).on('turbolinks:load', function() {
  function updateVote(data, isVoting) {
    let voteClass = '.vote-' + data.resource_class + '-' + data.id;

    $(voteClass + ' .total-votes').html(data.votes);
    
    if (isVoting) {
      $(voteClass + ' .voting').addClass('hidden');
      $(voteClass + ' .recall-link').removeClass('hidden');
    } else {
      $(voteClass + ' .recall-link').addClass('hidden');
      $(voteClass + ' .voting').removeClass('hidden');
    }
  }

  $('.vote .voting').on('ajax:success', function(e) {
    let data = e.detail[0];
    updateVote(data, true);
  })
    .on('ajax:error', function (e) {  
      let errors = e.detail[0];
      
      $('.vote-errors').empty()
      
      $.each(errors, function(index, value) {
        $('.vote-errors').append('<p>' + value + '</p>');
      })
    })

  $('.vote .recall').on('ajax:success', function(e) {
    let data = e.detail[0];
    updateVote(data, false);
  });
});
