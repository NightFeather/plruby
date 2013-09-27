# encoding: utf-8
require './ansi_color.rb'
require './log.rb'

def parseTime( org )
    return @ptime = "%04d-%02d%02dT%02d:%02d:%02d" % [org.year,org.mon,org.day,org.hour,(org.min-5),org.sec]
end

def readFile
    $all_pattern = {}
    @loadin = ""
    @file = File.new("patterns.hey","r")
    @file.each_line do |line|
        case line
            when /^==/
                @loadin = line[2..-1]
                $all_pattern[@loadin] = []
            when /^#/
            else
                $all_pattern[@loadin] << line
        end
    end
end

def autoReplurk
    $log.logger("aResp Started.")
    readFile
    @tid = Thread.new {
                        while true
                            @t = Time.new
                            @off = parseTime( @t.utc )
                            @returnPlurk = $plurk.req("/APP/Polling/getPlurks",{:offset => @off})
                            @returnPlurk["plurks"].each do |got| 
                                $all_pattern.each_key do |key|
                                    if got["content_raw"] =~ /#{key}/
                                        $plurk.resp(got["plurk_id"],rand(all_pattern[key].lengh))
                                    end
                                end
                            end
                            sleep 2
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
                    $log.logger("Testing Work Self Ended.")
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
 