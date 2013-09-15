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
        $log.logger "Terminal Interface Started."
        @prompt = prompt
        @tid = nil
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
            parsedCmd = (cmd.scan /(\w+)|"([\w\s]+?)"/).flatten.compact
            case parsedCmd[0]
                when /post/i
                     if parsedCmd[1]
                        content = parsedCmd[1]
                        ppost(content,parsedCmd[2])
                     else
                        print ConColor("GRE") + "Usage: post <content> [modifier]" + ConColor() + "\n"
                        print ConColor("GRE") + "content must be quoted" + ConColor() + "\n"
                     end
                when /log/i
                     print $log.logger()
#Need to be rewrite
                when /start/i 
                    if parsedCmd[1]
                        unless @tid
                           puts "Starting Worker thread"
                           @tid = worker parsedCmd[1]
                           sleep 0.01
                         else
                            puts "there's a thread already running!!"
                         end
                     else
                        print ConColor("GRE")  +  "Please specify an argument to detemine which type of work to go!" + ConColor() + "\n"
                     end
#Need to be rewrite
                when /stop/i
                    begin
                     @tid.kill
                     @tid = nil
                    rescue
                     print ConColor("GRE") + "No Working thread to Stop!! \nAre you sure there's a thread running?" + ConColor() + "\n"
                    end
                when /list/i
                    p @tid
                    print "\n"
                when /help/i
                     print ConColor("GRE") + "post  => Plurks a message" +  ConColor() + "\n"
                     print ConColor("GRE") + "log   => Show log" +  ConColor() + "\n"
                     print ConColor("GRE") + "start => Start a bot thread" +  ConColor() + "\n"
                     print ConColor("GRE") + "stop  => Stop a working thread" +  ConColor() + "\n"
                     print ConColor("GRE") + "exit  => Leave this console" +  ConColor() + "\n"
                     print ConColor("GRE") + "help  => Show this message" +  ConColor() + "\n"
                when /exit/i
                    $log.logger ("Terminal Interface Ended.")
                    $log.write
                    puts ConColor("CYN") + "exiting...." + ConColor()
                    break
                else 
                    puts ConColor("RED") + "Command not found." + ConColor()
                    puts ConColor("GRE") + "Enter \"help\" for avalible command list."  + ConColor()
            end
        end
    end
end
