SCHEDULER.every '3600s', :first_in => 0 do |job|
    time = Time.now
    hour = time.hour
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
    send_event('greeting', { :message => message, :hour => hour})
end

