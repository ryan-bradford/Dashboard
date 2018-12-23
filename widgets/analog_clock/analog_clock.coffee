class Dashing.AnalogClock extends Dashing.Widget

  ready: ->
    setInterval (->
      hours = (new Date).getHours()
      mins = (new Date).getMinutes()
      hdegree = hours * 30 + mins / 2
      hrotate = 'rotate(' + hdegree + 'deg)'
      $('#hour').css
        '-moz-transform': hrotate
        '-webkit-transform': hrotate
      return
    ), 1000

    setInterval (->
      mins = (new Date).getMinutes()
      mdegree = mins * 6
      mrotate = 'rotate(' + mdegree + 'deg)'
      $('#min').css
        '-moz-transform': mrotate
        '-webkit-transform': mrotate
      return
    ), 1000
