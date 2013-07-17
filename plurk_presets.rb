# encoding: utf-8
require 'json'
require 'oauth'
require './plurk.rb'
require './ansi_color.rb'

class Log
    def initialize
        @tname = Time.new
        @fname = "plurbybot-%04d%02d%02d.log" % [ @tname.year, @tname.mon, @tname.day]
        @f = File.new(@fname,"a+")
    end
    def logger( n = nil )
        if n
           @log += n.to_s + "\n"
           return 0
        else
           return @log
        end
    end
    def write
        if @log
            @tline = Time.new
            @log  = "==%02d:%02d:%02d==\n" % [ @tline.hour, @tline.min, @tline.sec ] + @log
            @log += "========end=======\n"
            @f.write(@log)
            @log = nil
        end
    end
end

def ppost(c ,q = nil ,l = nil)
    @c, @q, @l = c, q, l
    if @q == nil
        @q = ":"
    end
    if @l == nil
        @l = "tr_ch"
    end
    $plurk.post('/APP/Timeline/plurkAdd',{:content=>@c, :qualifier=>@q, :lang=>@l},)
end

def resp(id, c, q)
    @id, @c, @q = id, c, q
    $plurk.post('/APP/Responses/responseAdd',{:id=>@id, :content=>@c, :qualifier=>@q},)
end
class Terminal
    def initialize ( prompt = nil )
        @prompt = prompt
        if !@prompt
            @prompt = "PlurbyBot>"
        end
        @prompt = ConColor("YEL") + @prompt + " " + ConColor()
    end
    def queue(mesg)
    end
    def console
    $flag = true
        while $flag
            print @prompt
            cmd = gets.chomp
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
                when "exit", "Exit", "q", "quit", "Quit"
                    puts ConColor("CYN") + "exiting...." + ConColor()
                    $flag = false
                else puts ConColor("RED") + "Command not found" + ConColor()
            end
        end
    end
end
