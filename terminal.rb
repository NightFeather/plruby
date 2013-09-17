# encoding: utf-8
require './log.rb'
require './plurk.rb'
require './ansi_color.rb'
require './constants.rb'
require './action.rb'

class Terminal
    def initialize (prompt = "PlurbyBot>")
        @prompt = prompt
        $log.logger "Terminal Interface Started."
    end
    def out ( input , hcolor = "GRE" ,n=1)
        print ConColor(hcolor) + input.to_s + ConColor() + ("\n"*n)
    end
    def console
        while true
            sleep 0.1
            out(@prompt,"YEL",0)
            cmd = readline.chomp
            parsedCmd = (cmd.scan /(\w+)|"([^"']+?)"|'([^"']+?)'/).flatten.compact
            case parsedCmd[0]
            when /post/i
                if parsedCmd[1]
                    content = parsedCmd[1]
                    $plurk.post(content,parsedCmd[2])
                    $log.logger ("posted a message \"%s\"" % [content])
                 else
                    out "Usage: post <content> [modifier]"
                    out "content must be quoted"
                 end
            when /start/i
                worker(parsedCmd[1],parsedCmd[2..-1])
            when /stop/i
            when /list/i
            when /log/i
                print $log.logger
            when /help/i
                out  "post  => Plurks a message"
                out  "log   => Show log"
                out  "start => Start a bot thread"
                out  "stop  => Stop a working thread"
                out  "exit  => Leave this console"
                out  "help  => Show this message"
            when /exit/i
                $log.logger ("Terminal Interface Ended.")
                $log.write
                out "exiting....", "CYN"
                break
            else
                out "Command not found." , "RED"
                out "Enter \"help\" for avalible command list."
            end
        end
    end
end