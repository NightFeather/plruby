#!/usr/bin/env ruby 
# encoding: utf-8

require './log.rb'

$log = Log.new
Thread.new {
    while true
        comp = Time.new
        $log.write
        if $log.tname.day != comp.day
            $log.logger("Start changing LogFile!")
            $log.write
            $log.update_file
            $log.logger("LogFile have changed! A brand new day comes!")
        end
        sleep 30
    end
}

def quit(*mesg)
    @mesg = mesg
    @mesg = @mesg.join "\n"
    $log.logger @mesg
    $log.write
    exit
end

trap("TERM") do
    print "\n"
    quit "I need to go because system going down."
end
trap("INT") do
    print "\n"
    quit "Forced Shutdown by ctrl-c."
end

require './gen.rb'

if !File.exist?("setting.rb")
    gen = Gen.new
    gen.getSetting
    gen.writeSetting
end

require './setting.rb'
require './plurk.rb'
require './terminal.rb'

$plurk = Plurk.new(Consts::Apk, Consts::Aps)
$plurk.authorize(Consts::Act, Consts::Acs)

begin
    unless ARGV[0]
        terminal = Terminal.new
        terminal.console
    end 
rescue
    quit $!,$@
end
