require 'net/http'
require 'dotenv/load'
require 'json'
 
url = 'api.openweathermap.org'
extension = '/data/2.5/weather?q=Boston,us&APPID=' + ENV['WEATHER']

 
SCHEDULER.every '36000s', :first_in => 0 do |job|
  http = Net::HTTP.new(url)
  response = http.request(Net::HTTP::Get.new(extension))
  json = JSON.parse(response.body)
  temp = 1.8*(json["main"]['temp']-273) + 32
  time = Time.now
  hour = time.hour + time.min/60 + time.sec/3600
  message = ""
  if hour > 18
    message = "Good Night..."
  elsif hour > 15
    message = "Good Evening."
  elsif hour > 11
    message = "Good Afternoon!"
  elsif hour > 4
    message = "Good Morning"
  else
    message = "Zzzzzz...."
  end
  send_event('weather', { :temp => temp.round,
                          :condition => json['weather'][0]['description'],
                          :title => "Boston Weather",
                          :climacon => climacon_class(json['weather'][0]['icon']),
                          :message => message, 
                          :hour => hour})
end


def climacon_class(weather_code)
  case weather_code
  when "01d" 
    'sun'
  when "01n" 
    'moon'
  when "02d" 
    'cloud sun'
  when "02n" 
    'cloud moon'
  when "03d" 
    'cloud'
  when "03n" 
    'cloud'
  when "04d" 
    'fog'
  when "04n" 
    'fog'
  when "09d" 
    'drizzle'
  when "09n" 
    'drizzle'
  when "10d" 
    'rain'
  when "10n" 
    'rain'
  when "10d" 
    'lightning'
  when "10n" 
    'lightning'
  when "11d" 
    'snow'
  when "11n" 
    'snow'
  when "50d" 
    'haze'
  when "50n" 
    'haze'
  end
end

SCHEDULER.every '3600s', :first_in => 0 do |job|
  
end
