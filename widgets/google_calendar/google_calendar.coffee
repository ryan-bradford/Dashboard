class Dashing.GoogleCalendar extends Dashing.Widget

  onData: (data) =>
    event = rest = null
    getEvents = (first, others...) ->
      event = first
      rest = others

    getEvents data.events...
    
    start = event.start.replace /\ UTC/, "-0000"
    console.log(start)
    start = moment(start)
    console.log(start)
    start = start.tz('America/New_York')
    end = event.end.replace /\ UTC/, "-0000"
    end = moment(end).utcOffset(0)
    end = end.tz('America/New_York')

    @set('event',event)
    @set('event_date', start.format('dddd Do MMMM'))
    @set('event_times', start.format('HH:mm') + " - " + end.format('HH:mm'))

    next_events = []
    for next_event in rest
      start = next_event.start.replace /\ UTC/, "-0000"
      start = moment(start).utcOffset(0)
      start = start.tz('America/New_York')
      start_date = start.format('Do MMM')
      start_time = start.format('HH:mm')

      next_events.push { summary: next_event.summary, start_date: start_date, start_time: start_time }
    @set('next_events', next_events)
