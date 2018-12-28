require 'icalendar'

ical_url = 'https://calendar.google.com/calendar/ical/ryanbradford333%40gmail.com/private-f615b63cb8dc935cc13d15ce78b22b5d/basic.ics'
uri = URI ical_url

SCHEDULER.every '15s', :first_in => 4 do |job|
  result = Net::HTTP.get uri
  calendars = Icalendar::Calendar.parse(result)
  calendar = calendars.first

  events = calendar.events.map do |event|
    {
      start: event.dtstart,
      end: event.dtend,
      summary: event.summary
    }
  end.select { |event| event[:start] > DateTime.now }

  events = events.sort { |a, b| a[:start] <=> b[:start] }

  events = events[0..5]

  send_event('google_calendar', { events: events })
end
