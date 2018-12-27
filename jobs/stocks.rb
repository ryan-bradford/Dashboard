require 'net/http'
require 'dotenv/load'
require 'json'
 
def getStock(id, name) 
    puts id
    puts name
    uri = URI("https://api.iextrading.com/1.0/stock/#{id}/batch?types=quote")#,chart&range=1m&last=10')
    Net::HTTP.start(uri.host, uri.port,
    :use_ssl => uri.scheme == 'https') do |http|
    request = Net::HTTP::Get.new uri

    response = http.request request # Net::HTTPResponse object
    json = JSON.parse(response.body)
    quote = json['quote']
    isClosed = quote['latestSource'].eql? 'Close'
    prevClose = quote['previousClose'].round(1)
    curClose = quote['latestPrice'].round(1)
    return { current: curClose, last: prevClose, name: name }
    end
end

SCHEDULER.every '60s', :first_in => 0 do |job|
    stocks = [{id: "SPY", name: "S&P"}, {id: "CCMP", name: "Nasdaq"}, {id: "INDU", name: "Dow Jones"}]
    stocksToRet = []
    stocks.each do |stock|
        print stock[:id]
        stocksToRet.push(getStock(stock[:id], stock[:name]))
    end
    send_event('stock', {:stocks => stocksToRet})
end
