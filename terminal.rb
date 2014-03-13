# encoding: utf-8
load './log.rb'
load './plurk.rb'
load './ansi_color.rb'
load './setting.rb'
load './action.rb'

class Terminal
    include AnsiColor
    def initialize (prompt = "PlurbyBot>")
        @prompt = prompt
        $log.logger "Terminal Interface Started."
        $thread_list = {}
    end
    def console
        while true
            sleep 0.1
            out(@prompt,:yel,0)
            cmd = readline.chomp!
            parsedCmd = (cmd.scan /(\w+)|"([^"']+?)"|'([^"']+?)'/).flatten.compact
            if !parsedCmd[0] then next end
            case parsedCmd.shift
                when /get/i
                    p parseTime( (Time.new).utc )
                    p $plurk.req("/APP/Polling/getPlurks",{:offset => parseTime( (Time.new).utc )})
                when /post/i
                    if parsedCmd[0]
                        $plurk.post *parsedCmd[0..1]
                    else
                        out "Usage: post <content> [modifier]"
                        out "content must be quoted"
                    end
                when /resp/i
                    if parsedCmd[0] && parsedCmd[1]
                        plurk_id ,content = parsedCmd[0].to_i, parsedCmd[1]
                        $plurk.resp(plurk_id,content)
                     else
                        out "Usage: post <plurk_Id> <content> [modifier]"
                        out "content and plurk_Id must be quoted"
                     end
                when /start/i
                    worker *parsedCmd
                when /stop/i
                    case parsedCmd[0]
                     when /1/
                      $thread_list["Karma_Hold"].kill
                      $thread_list.delete "Karma_Hold"
                     when /2/
                      $thread_list["aResp"].kill
                      $thread_list.delete "aResp"
                     else
                      out "Syntax Error" ,:red
                    end
                when /list/i
                    $thread_list.each_pair do |name,stat| 
                        puts "%s\t%s" % [ name,stat.status ]
                    end
                when /log/i
                    print $log.logger
=begin  試做模組動態載入 030
                when /part/i
                    case parsedCmd[1]
                        when /list/i
                end                    
=end
                when /tick/i
                    tick
                when /help/i
                    out <<-EOM.gsub(/^\s+/,"")
                        get   => get plurks
                        post  => Plurks a message
                        log   => Show log
                        start => Start a bot thread
                        stop  => Stop a working thread
                        part  => manage parts loaded
                        exit  => Leave this console
                        quit  => Leave this console
                        help  => Show this message
                    EOM
                when /exit|quit/i
                    out "exiting....", :cyn
                    quit "Terminal Interface Ended."
                else
                    out "Command \"#{parsedCmd[0]}\" not found." , "RED"
                    out "Enter \"help\" for avalible command list."
            end
        end
    end
end
