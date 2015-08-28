calculateTime = (startTime) -> 
  finalTime = $.now()
  answerTime = (finalTime - startTime) / 1000
  $('<input />').attr('type', 'hidden')
    .attr('name', 'review[answer_time]')
    .attr('value', answerTime)
    .appendTo('#review_form')

checkAnswer = ->
  startTime = $.now()
  $('#review_form').submit (e) ->
    e.preventDefault()
    calculateTime(startTime)
    sendRequest = $.post("reviews", $('#review_form').serialize(), null, "json")
    sendRequest.done (data)->
      if data.result
        $("#flash").empty().append(
          $('<div />').attr('class', 'alert alert-info fade in').append(
            "<a aria-label='close', class='close', data-dismiss='alert', href='#', title='close'>&times</a>"
          ).append(data.message)
        )
      else
        $("#flash").empty().append(
          $('<div />').attr('class', 'alert alert-danger fade in').append(
            "<a aria-label='close', class='close', data-dismiss='alert', href='#', title='close'>&times</a>"
          ).append(data.message)
        )
      if data.result || data.reload
        $.get("reviews/new", null, null, "script")
      $('#review_form').off("submit")

$(document).ready ->
  checkAnswer()

$(document).ajaxComplete ->
  checkAnswer()
