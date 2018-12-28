require 'net/http'
require 'dotenv/load'
require 'json'
 
def getChange(cur, last)
    return (((cur - last) / last)*100).round(1)
end

def getIcon(cur, last)
    if cur > last
        return 'fa fa-arrow-up'
    else
        return 'fa fa-arrow-down'
    end
end

def getStock(id, name) 
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
    return { current: curClose, last: prevClose, name: name, icon: getIcon(curClose, prevClose), change: getChange(curClose, prevClose) }
    end
end

SCHEDULER.every '60s', :first_in => 0 do |job|
    stocks = [{id: "SPY", name: "S&P"}, {id: "ONEQ", name: "Nasdaq"}, {id: "DIA", name: "Dow Jones"}]
    stocksToRet = []
    stocks.each do |stock|
        stocksToRet.push(getStock(stock[:id], stock[:name]))
    end
    send_event('stock', {:stocks => stocksToRet})
end
