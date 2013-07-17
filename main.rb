# encoding: utf-8
require 'json'
require 'oauth'
require './plurk.rb'
require './plurk_presets.rb'
require './constants.rb'

$plurk = Plurk.new(Consts::Apk, Consts::Aps)

$plurk.authorize(Consts::Act, Consts::Acs)

terminal = Terminal.new
terminal.console
