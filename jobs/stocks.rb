require 'net/http'
require 'dotenv/load'
require 'json'
 
SCHEDULER.every '3600s', :first_in => 0 do |job|
    uri = URI('https://api.iextrading.com/1.0/stock/SPY/batch?types=quote')#,chart&range=1m&last=10')
    Net::HTTP.start(uri.host, uri.port,
    :use_ssl => uri.scheme == 'https') do |http|
    request = Net::HTTP::Get.new uri

    response = http.request request # Net::HTTPResponse object
    json = JSON.parse(response.body)
    quote = json['quote']
    isClosed = quote['latestSource'].eql? 'Close'
    prevClose = quote['previousClose'].round(1)
    curClose = quote['latestPrice'].round(1)
    change = (((curClose - prevClose) / prevClose)*100)
    change = change.round(2)
    wentDown = change < 0
    send_event('valuation', { current: curClose, last: prevClose })
    end
end

