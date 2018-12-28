require 'net/http'
require 'json'

placeholder = '/assets/images/placeholder.gif'

SCHEDULER.every '360s', first_in: 0 do |job|
    uri = URI("https://www.reddit.com/r/aww.json")
    Net::HTTP.start(uri.host, uri.port,
    :use_ssl => uri.scheme == 'https') do |http|
        request = Net::HTTP::Get.new uri
        request['User-agent'] = 'Ryan Dash'
        response = http.request request # Net::HTTPResponse object
        json = JSON.parse(response.body)
        puts json
        if json['data']['children'].count <= 0
            send_event('aww', image: placeholder)
        else
            urls = json['data']['children'].map{|child| child['data']['url'] }

            # Ensure we're linking directly to an image, not a gallery etc.
            valid_urls = urls.select{|url| url.downcase.end_with?('png', 'gif', 'jpg', 'jpeg')}
            send_event('aww', image: "background-image:url(#{valid_urls.sample(1).first})")
        end
    end 
end