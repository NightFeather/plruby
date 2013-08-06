# encoding: utf-8
require './ansi_color.rb'

def autoReplurk (off)
        @off = off.to_s
        post("/APP/Polling/getPlurks",{:offset => @off})
end

def hourlytest (in_str)
        if in_str
                @in_str = in_str.to_s
        else
                @in_str = "先試跑 每小時來一次\n 雖然我覺得這種程度的功能\n 用 crontab 還比較方便[oh]"
        end
        while true 
                begin
                time = Time.new
                        if time.min == 0
                                ppost(@in_str)
                                sleep 3600
                        end
                rescue
                        $log.logger("Hourly post failed. Network issue?")
                        sleep 3600
                end
        end
end

def parseTime( org )
        return @ptime = "%04d-%02d%02dT%02d:%02d:%02d" % [org.year,org.mon,org.day,org.hour,org.min,org.sec]
end
def worker(n)
        begin
        @tid = Thread.new {
                puts ConColor("CYN") + "Online!!" + ConColor()
                        case n
                                when 1
                                        hourlytest
                                when 2
                                        while true
                                                begin
                                                        @dummy = 0
                                                        time = Time.new
                                                        otime = parseTime(time)
                                                        autoReplurk
                                                        if time.hour % 2 ==0
                                                                $log.write
                                                        end
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
                                        puts("Syntax Error")
                        end
        }
        return @tid
        rescue
                puts "Unable to Start the worker thread. Please Try again!"
        end
 end
 