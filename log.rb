
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
