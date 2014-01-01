# encoding: utf-8
require './ansi_color.rb'
require './log.rb'

def parseTime( org )
    return @ptime = "%04d-%02d-%02dT%02d:%02d:%02d" % [org.year,org.mon,org.day,org.hour,org.min,org.sec]
end

def readFile
    $all_pattern = {}
    @loadin = ""
    @file = File.new("patterns.hey","r")
    @file.each_line do |line|
        line.chomp!
        case line
            when /^==/
                unless @loadin then $all_pattern[@loadin].flatten!.compact! end
                @loadin = line[2..-1]
                $all_pattern[@loadin] = []
            when /^#/
                #Do Nothing
            else
                $all_pattern[@loadin] << line
        end
    end
    p $all_pattern
end

def autoReplurk
    $log.logger("aResp Started.")
    readFile
    @tid = Thread.new {
                        while true
                            @off = parseTime( (Time.new).utc )
                            puts @off
                            sleep 2
                            @returnPlurk = $plurk.req("/APP/Polling/getPlurks",{:offset => @off,:limit => 20})
                            if @returnPlurk["plurks"].length
                                @returnPlurk["plurks"].each do |got|
                                    $all_pattern.each_key do |key|
                                        if (got["content_raw"] =~ /#{key}/) != nil
                                            $plurk.resp(got["plurk_id"].to_i,$all_pattern[key][rand($all_pattern[key].length)])
                                        end
                                    end
                                end
                                $log.logger("aResp One cycle done.")
                            end
                        end
                 }
    return @tid
end

def testing (in_str)
    @dummy = 0
    if in_str
        @in_str = in_str.length > 0 ? in_str :  ["嗚嚕[oh]","呼嚕[cat]","姆嚕[nu]","咕嚕[goro]"]
    else
        @in_str = ["嗚嚕[oh]","呼嚕[cat]","姆嚕[nu]","咕嚕[goro]"]
    end
    @base = @in_str.length > 24 ? 24 : @in_str.length
    $log.logger("Karma_Hold Started with patterns : %s " % [(@in_str.join " ")])
    @tid = Thread.new {
                $plurk.post("Errr, Something Online?")
                while @dummy <5
                    begin
                        time = Time.new
                        if time.hour%(24/@base) ==0 && time.min == 0
                            $plurk.post(@in_str[time.hour/(24/@base)])
                            @dummy = 0
                        end
                            sleep 60
                    rescue
                        @dummy += 1
                        $log.logger("Hourly post failed. Network issue?")
                        sleep 60
                    end
                end
                $log.logger("Testing Work Self Ended Due to Some Reasons")
                $plurk.post("Errr, Something Offline?")
            }
    return @tid
end
#/
def worker( n , a = nil )
    begin
        case n
            when /1/
                puts ConColor("CYN") + "Online!!" + ConColor()
                $thread_list["Karma_Hold"] = testing a
            when /2/
                puts ConColor("CYN") + "Online!!" + ConColor()
                $thread_list["aResp"] = autoReplurk
            else
                puts "Syntax Error"
        end
    rescue
        puts "Unable to Start the worker thread. Please Try again!"
    end
 end
 
