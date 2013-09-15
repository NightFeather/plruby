#!/usr/bin/env ruby 
# encoding: utf-8
require 'json'
require 'oauth'
require './plurk.rb'
require './plurk_presets.rb'
require './constants.rb'
require './log.rb'

$plurk = Plurk.new(Consts::Apk, Consts::Aps)
$plurk.authorize(Consts::Act, Consts::Acs)

$log = Log.new
Thread.new {
    while true
        $log.write
        sleep 60
    end
}

unless ARGV[0]
    terminal = Terminal.new
    terminal.console
end
