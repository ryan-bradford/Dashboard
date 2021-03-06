require 'icalendar'
require 'dotenv/load'

ical_url = ENV['CALENDAR']
uri = URI ical_url

## https://api-v3.mbta.com/predictions?filter[stop]=door-knncl-sbmain&filter[start]=place-nuniv&include=stop
## https://api-v3.mbta.com/predictions?filter[stop]=place-nuniv&filter[start]=place-nuniv&include=stop
## https://api-v3.mbta.com/schedules?filter[route]=Green-E&filter[start]=place-nuniv&[stop]=door-knncl-sbmain
## https://api-v3.mbta.com/schedules?filter[route]=LINE&filter[start]=START&[stop]=END
routes = [{ :name => "NEU->PRK",
            :start => "place-nuniv",
            :line => 'Green-E',
            :direction => 1},
          { :name => "KEN->PRK",
            :start => "place-knncl",
            :line => 'Red',
            :direction => 0},
          { :name => "RUG->OAK",
            :start => "place-rugg",
            :line => 'Orange',
            :direction => 1}]

SCHEDULER.every '15s', :first_in => 4 do |job|
  output = routes;
  for route in output
    route[:arrivalMins] = getProjection(route);
  end
  send_event('arrivals', {:output => output})
end

def getProjection(hash) 
  uri = URI("https://api-v3.mbta.com/predictions?filter[direction_id]=#{hash[:direction]}&filter[stop]=#{hash[:start]}&filter[route]=#{hash[:line]}")
  Net::HTTP.start(uri.host, uri.port,
  :use_ssl => uri.scheme == 'https') do |http|
    request = Net::HTTP::Get.new uri

    puts uri;
    response = http.request request # Net::HTTPResponse object
    json = JSON.parse(response.body)
    data = json['data']
    if data.length > 0 
      for datum in data
        attributes = datum['attributes'];
        arivalTime = attributes['arrival_time'];
        if arivalTime != nil 
          d = DateTime.parse(arivalTime);
          if d > DateTime.now
            return -((DateTime.now - d)*24*60).to_i;
          end
        end
      end
    end
    return "NA";
  end
end
