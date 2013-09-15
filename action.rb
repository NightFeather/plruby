# encoding: utf-8
require './ansi_color.rb'

def autoReplurk (off)
    @off = off.to_s
    post("/APP/Polling/getPlurks",{:offset => @off})
end

def testing (in_str = nil)
    if in_str
        @in_str = in_str.to_s
    else
        @in_str = "嗚嚕[oh]"
    end
    while true 
        begin
        time = Time.new
            if time.hour%4 ==0 && time.min == 0
                ppost(@in_str)
                sleep 60
            end
        rescue
            $log.logger("Hourly post failed. Network issue?")
            sleep 60
        end
    end
    $log.logger("Testing Work Self Ended.")
end

def parseTime( org )
    return @ptime = "%04d-%02d%02dT%02d:%02d:%02d" % [org.year,org.mon,org.day,org.hour,org.min,org.sec]
end

def worker(n)
    begin
        @tid = Thread.new {
            puts ConColor("CYN") + "Online!!" + ConColor()
                case n
                    when /1/
                        testing
                    when /2/
                        while true
                            begin
                                time = Time.new
                                otime = parseTime(time)
                                autoReplurk
                                sleep 10
                            rescue
                                @dummy += 1
                                sleep 50
                                if @dummy < 5
                                    retry
                                else
                                    $log.logger("Something Wrong With AutoReplurk. Check net connection!")
                                    break
                                end
                            end
                        end
                    else
                        puts "Syntax Error"
                end
        }
        return @tid
    rescue
        puts "Unable to Start the worker thread. Please Try again!"
    end
 end
 