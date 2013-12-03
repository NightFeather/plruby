# encoding: utf-8
require './log.rb'
require './plurk.rb'
require './ansi_color.rb'
require './setting.rb'
require './action.rb'

class Terminal
    def initialize (prompt = "PlurbyBot>")
        @prompt = prompt
        $log.logger "Terminal Interface Started."
        $thread_list = {}
    end
    def out ( input , hcolor = "GRE" ,n=1)
        print ConColor(hcolor,nil,1) + input.to_s + ConColor() + ("\n"*n)
    end
    def console
        while true
            sleep 0.1
            out(@prompt,"YEL",0)
            cmd = readline.chomp!
            parsedCmd = (cmd.scan /(\w+)|"([^"']+?)"|'([^"']+?)'/).flatten.compact
            case parsedCmd[0]
            when /get/i
                p $plurk.req("/APP/Polling/getPlurks",{:offset => parseTime( (Time.new).utc )})
            when /post/i
                if parsedCmd[1]
                    content = parsedCmd[1]
                    $plurk.post(content,parsedCmd[2])
                 else
                    out "Usage: post <content> [modifier]"
                    out "content must be quoted"
                 end
            when /resp/i
                if parsedCmd[1] && parsedCmd[2]
                    plurk_id ,content = parsedCmd[1].to_i, parsedCmd[2]
                    $plurk.resp(plurk_id,parsedCmd[2])
                 else
                    out "Usage: post <plurk_Id> <content> [modifier]"
                    out "content and plurk_Id must be quoted"
                 end
            when /start/i
                worker(parsedCmd[1],parsedCmd[2..-1])
            when /stop/i
                case parsedCmd[1]
                 when /1/
                  $thread_list["Karma_Hold"].kill
                  $thread_list.delete "Karma_Hold"
                 when /2/
                  $thread_list["aResp"].kill
                  $thread_list.delete "aResp"
                 else
                  out "Syntax Error" ,"RED"
                end
            when /list/i
                $thread_list.each_pair do |name,stat| 
                    puts "%s\t%s" % [name,stat.status]
                end
            when /log/i
                print $log.logger
            when /help/i
                out  "get   => get plurks"
                out  "post  => Plurks a message"
                out  "log   => Show log"
                out  "start => Start a bot thread"
                out  "stop  => Stop a working thread"
                out  "exit  => Leave this console"
                out  "help  => Show this message"
            when /exit/i
                out "exiting....", "CYN"
                quit "Terminal Interface Ended."
            else
                if parsedCmd[0]
                    out "Command not found." , "RED"
                    out "Enter \"help\" for avalible command list."
                end
            end
        end
    end
end
