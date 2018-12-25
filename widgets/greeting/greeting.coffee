night_red = 18
night_green = 25
night_blue = 91
day_red = 240
day_green = 234
day_blue = 110

class Dashing.Greeting extends Dashing.Widget
    onData: (data) ->
        x = data['hour']
        percent_day = -((x-0)*(x-24))/145
        x = (x + 12) %% 24 
        percent_night = -((x-0)*(x-24))/145
        cur_red = Math.round(night_red*percent_night + day_red*percent_day)
        cur_green = Math.round(night_green*percent_night + day_green*percent_day)
        cur_blue = Math.round(night_blue*percent_night + day_blue*percent_day)
        console.log("rgb(#{cur_red}, #{cur_green}, #{cur_blue})")
        $(@node).css('background', "rgb(#{cur_red}, #{cur_green}, #{cur_blue})")