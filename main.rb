#!/usr/bin/env ruby 
# encoding: utf-8

require './plurk.rb'
require './terminal.rb'
require './constants.rb'
require './log.rb'

$plurk = Plurk.new(Consts::Apk, Consts::Aps)
$plurk.authorize(Consts::Act, Consts::Acs)

$log = Log.new
Thread.new {
    while true
        comp = Time.new
        $log.write
        if $log.tname.day != comp.day
            $log.logger("Start changing LogFile!")
            $log.update_file
            $log.logger("LogFile have changed! A brand new day comes!")
        end
        sleep 60
    end
}

unless ARGV[0]
    terminal = Terminal.new
    terminal.console
end
