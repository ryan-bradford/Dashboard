class Dashing.Stock extends Dashing.Widget

  counter = 0

  @accessor 'current', ->
    console.log("here")
    Dashing.AnimatedValue

  @accessor 'difference', ->
    cur = @get('stocks')[counter]
    counter += 1    
    console.log(@get('stocks'))
    if cur.last
      last = parseInt(cur.last)
      current = parseInt(cur.current)
      if last != 0
        diff = Math.abs(Math.round((current - last) / last * 1000)/10)
        "#{diff}%"
    else
      ""

  @accessor 'arrow', ->
    cur = @get('stocks')[counter]
    if cur.last
      if parseInt(cur.current) > parseInt(cur.last) then 'fa fa-arrow-up' else 'fa fa-arrow-down'

  onData: (data) ->
    counter = 0
    if data.status
      # clear existing "status-*" classes
      $(@get('node')).attr 'class', (i,c) ->
        c.replace /\bstatus-\S+/g, ''
      # add new class
      $(@get('node')).addClass "status-#{data.status}"
