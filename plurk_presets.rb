# encoding: utf-8
require 'json'
require 'oauth'
require './plurk.rb'
require './ansi_color.rb'
require './constants.rb'

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

def console
    $flag = true
    while $flag
        xx = ConColor "YEL"
        xx += "PlurbyBot>"
        xx += ConColor()
        print xx
        cmd = gets.chomp
        parsedCmd = cmd.split
        case parsedCmd[0]
            when "post", "Post", "POST"
                 content = parsedCmd[1]
                 cmdl = parsedCmd.length
                 if cmdl > 2
                    i = 2
                    while cmdl > i
                        content = content + " " + parsedCmd[i]
                        i += 1
                    end
                 end
                 ppost(content)
            when "exit", "Exit", "q", "quit", "Quit"
                puts ConColor("CYN") + "exiting...." + ConColor()
                $flag = false
            else puts ConColor("RED") + "Command not found" + ConColor()
        end
    end
end

