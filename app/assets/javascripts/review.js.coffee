jQuery ($) ->
  $(document).ready ->
    startTime = $.now()

    $('#review_form').submit (e) ->
      finalTime = $.now()
      answerTime = (finalTime - startTime) / 1000
      $('<input />').attr('type', 'hidden')
        .attr('name', 'review[answer_time]')
        .attr('value', answerTime)
        .appendTo('#review_form')
