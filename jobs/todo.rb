require 'net/http'
require 'dotenv/load'
require 'todoist'

@client = Todoist::Client.create_client_by_login(ENV['TODOIST_USER'], ENV['TODOIST_PASS'])

SCHEDULER.every '20s', :first_in => 0 do |job|
    items = @client.sync_items.collection
    todo = []
    items.each do |x|
        date =  Date.parse x[1].date_string
        date_completed = x[1].date_completed
        is_deleted = x[1].is_deleted
        if date == Date.today && !(date_completed.instance_of? String) && is_deleted == 0
            todo.push({:content => x[1].content})
        end
    end
    send_event('todo', {:title => "Todo", :items => todo})
end