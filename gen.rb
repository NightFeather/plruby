# encoding: utf-8

class Gen
    def initialize
        @setting = Hash.new
        @content = []
    end

    def getSetting
        puts "這是一個初始化script"
        puts "依提示輸入各項設定："
        print "Application Key (abbr => Apk): "
            @setting["Apk"] = readline.chomp!
        print "Application Secret (abbr => Aps): "
            @setting["Aps"] = readline.chomp!
        print "Access Token (abbr => Act): "
            @setting["Act"] = readline.chomp!
        print "Access Secret (abbr => Acs): "
            @setting["Acs"] = readline.chomp!
        puts "Settings You've Entered："
        @setting.each {|name,value| puts name + ":\t" + ( value ? value : "<< Not Setted >>" )}
        print "結束設定？[Y/n] "
        if readline.chomp! =~ /n/i
            getSetting 
        else
            writeSetting
        end
    end

    def writeSetting
        @content << "module Settings"
        @setting.each { |name,value| @content << "\t" + name + " = " + "\'" +  value + "\'" }
        @content << "end"
        @f = File.new("setting.rb","w")
        @f.write (@content.join "\n")
        @f.close
    end
end