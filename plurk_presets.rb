# encoding: utf-8
require 'json'
require 'oauth'
require './plurk.rb'
require './ansi_color.rb'
require './action.rb'
require './log.rb'

def ppost(c ,q = nil ,l = nil)
    @c, @q, @l = c, q, l
    if @q == nil
        @q = ":"
    end
    if @l == nil
        @l = "tr_ch"
    end
    json = $plurk.post('/APP/Timeline/plurkAdd',{:content=>@c, :qualifier=>@q, :lang=>@l},)
    p json
end

def resp(id, c, q)
    @id, @c, @q = id, c, q
    $plurk.post('/APP/Responses/responseAdd',{:id=>@id, :content=>@c, :qualifier=>@q},)
end

#大部分的終端機控制
class Terminal
    def initialize ( prompt = nil )
        @prompt = prompt
        @tid = nil
        $log = Log.new
        unless @prompt
            @prompt = "PlurbyBot>"
        end
        @prompt = ConColor("YEL") + @prompt + " " + ConColor()
    end
    #主要的指令io控制
    def console
        while true
            print @prompt
            cmd = readline.chomp
            parsedCmd = cmd.split (/ "|" |"$/)
            case parsedCmd[0]
                when "post", "Post", "POST"
                     if parsedCmd[1]
                        content = parsedCmd[1]
                        ppost(content,parsedCmd[2])
                     else
                        print ConColor("GRE") + "Usage: post <content> [modifier]" + ConColor() + "\n"
                        print ConColor("GRE") + "content must be quoted" + ConColor() + "\n"
                     end
                when "Log", "LOG", "log"
                     print $log.logger()
                when "Start", "start", "START"
                     unless @tid
                    puts "Starting Worker thread"
                    @tid = worker
                    sleep 0.01
                     else
                    puts "there's a thread already running!!"
                     end
                when "STOP", "stop", "Stop"
                    begin
                    @tid.kill
                    @tid = nil
                    rescue
                    puts "No Working thread to Stop!! \nAre you sure there's a thread running?"
                    end
                when "exit", "Exit", "q", "quit", "Quit"
                    puts ConColor("CYN") + "exiting...." + ConColor()
                    break
                else puts ConColor("RED") + "Command not found" + ConColor()
            end
        end
    end
end
