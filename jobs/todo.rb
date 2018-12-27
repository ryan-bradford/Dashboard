require 'net/http'
require 'dotenv/load'
require 'todoist'

@client = Todoist::Client.create_client_by_login(ENV['TODOIST_USER'], ENV['TODOIST_PASS'])

SCHEDULER.every '600s', :first_in => 0 do |job|
    items = @client.sync_items.collection
    todo = []
    items.each do |x|
        date =  Date.parse x[1].date_string
        if date == Date.today
            todo.push({:content => x[1].content})
        end
    end
    send_event('todo', {:title => "Todo", :items => todo})
end