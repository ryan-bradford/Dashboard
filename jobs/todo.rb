require 'net/http'
require 'dotenv/load'
require 'todoist'

@client = Todoist::Client.create_client_by_login(ENV['TODOIST_USER'], ENV['TODOIST_PASS'])

SCHEDULER.every '20s', :first_in => 0 do |job|
    items = @client.sync_items.collection
    todo = []
    items.each do |x|
        if (x[1].due_date_utc.instance_of? String)
            date =  Date.parse x[1].due_date_utc
            puts date
            date_completed = x[1].date_completed
            is_deleted = x[1].is_deleted
            if date == Time.now.utc.to_date && !(date_completed.instance_of? String) && is_deleted == 0
                puts x[1]
                todo.push({:content => x[1].content})
            end
        end
    end
    send_event('todo', {:title => "To-Do", :items => todo})
end