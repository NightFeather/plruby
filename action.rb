# encoding: utf-8
load './ansi_color.rb'
load './log.rb'

def parseTime( org )
    return @ptime = "%04d-%02d-%02dT%02d:%02d:%02d" % [org.year,org.mon,org.day,org.hour,org.min,org.sec]
end

def readFile
    @all_pattern = {}
    @head = ""
    @file = File.new("patterns.hey","r")
    @file.each_line do |line|
        line.chomp!
        case line
            when /^==/
                @head = (line.match /^==(.+)/)[1]
                @all_pattern[@head] = []
            when /^#/
                next
            else
                @all_pattern[@head] << line
        end
    end
    return @all_pattern
end

def autoReplurk (*input)
    readFile
    p readFile
    #判斷回應
    #$plurk.resp(input[:plurk_id],@content)
    #$log.logger("aResp One cycle done.")
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
                $thread_list["tick"] = tick
            else
                puts "Syntax Error"
        end
    rescue
        puts "Unable to Start the worker thread. Please Try again!"
        puts $!
    end
 end
 
def tick
    @filter = /^CometChannel\.scriptCallback\((.+)\)\;/i
    @token = $plurk.req("/APP/Realtime/getUserChannel")
    @channel = @token["comet_server"].sub(/offset\=0/, 'offset=%d')
    @offset = -1
    ticker = Thread.new {
        while true
            @resp =  Net::HTTP.get( URI( @channel % [ @offset ] ) )
            @resp = @resp.match(@filter)[1]
            @resp = JSON.parse( @resp )
            @offset = @resp[:new_offset]
            @resp["data"].each do |data|
                case data[:type]
                when /new_plurk/i
                    autoReplurk({   :author=>data[:owner_id], 
                                    :plurk_id => data[:plurk_id],
                                    :qualifier => data[:qualifier],
                                    :content=>data[:content_raw]    })
                when /new_response/i
                else
                    out "~_~ Nothing To Do"
                end
            end
            sleep 10
        end
    }
    return ticker
end
