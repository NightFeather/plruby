# encoding: utf-8
require './ansi_color.rb'

def parseTime( org )
    return @ptime = "%04d-%02d%02dT%02d:%02d:%02d" % [org.year,org.mon,org.day,org.hour,org.min,org.sec]
end

def autoReplurk
    while true
        @t = Time.new
        @off = parseTime( @t.utc )
        @returnPlurk = $plurk.req("/APP/Polling/getPlurks",{:offset => @off})
        @returnPlurk["plurks"]
        sleep 2
    end
end

def testing (in_str = nil)
    if in_str.lengh
        @in_str = in_str
    else
        @in_str = ["嗚嚕[oh]","呼嚕[cat]","姆嚕[nu]","咕嚕[goro]"]
    end
    @base = @in_str.lengh > 24 ? 24 : @in_str.lengh
    while true 
        begin
            time = Time.new
            if time.hour%(24/@base) ==0 && time.min == 0
                $plurk.post(@in_str[time.hour%(24/@base)])
                sleep 60
            end
        rescue
            $log.logger("Hourly post failed. Network issue?")
            sleep 60
        end
    end
    $log.logger("Testing Work Self Ended.")
end

def worker( n , *a )
    begin
        @wid = Thread.new {
            puts ConColor("CYN") + "Online!!" + ConColor()
                case n
                    when /1/
                        testing a
                    when /2/
                        autoReplurk
                    else
                        puts "Syntax Error"
                end
        }
        return @wid
    rescue
        puts "Unable to Start the worker thread. Please Try again!"
    end
 end
 