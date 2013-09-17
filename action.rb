# encoding: utf-8
require './ansi_color.rb'

def parseTime( org )
    return @ptime = "%04d-%02d%02dT%02d:%02d:%02d" % [org.year,org.mon,org.day,org.hour,org.min,org.sec]
end

def readFile
    $all_pattern = {}
    @loadin = ""
    @file = File.new("patterns.hey","r")
    @file.each_line do |line|
        if /^==/ =~ line
            @loadin = line[2..-1]
        else
            $all_pattern[@loadin] << line
        end
    end
end

def autoReplurk
    readFiles
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

def testing (in_str = nil)
    if in_str.length
        @in_str = in_str
    else
        @in_str = ["嗚嚕[oh]","呼嚕[cat]","姆嚕[nu]","咕嚕[goro]"]
    end
    @base = @in_str.length > 24 ? 24 : @in_str.length
    @tid = Thread.new {
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
                }
    return @tid
end

def worker( n , *a )
    begin
        puts ConColor("CYN") + "Online!!" + ConColor()
        case n
            when /1/
                $wname = "Karma_Hold"
                @wid = testing a
            when /2/
                $wname = "aResp"
                @wid = autoReplurk
            else
                puts "Syntax Error"
        end
        $thread_list[$wname] = @wid
    rescue
        puts "Unable to Start the worker thread. Please Try again!"
    end
 end
 