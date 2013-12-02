# encoding: utf-8

class Log
    def log_open
        @tname = Time.new
        @fname = "plurbybot-%04d%02d%02d.log" % [ @tname.year, @tname.mon, @tname.day]
        @f = File.new(@fname,"a+")
    end
    def initialize
        log_open
        @log_s = []
        @s_lengh = 0
    end

    attr_reader :tname

    def logger( n = nil )
        if n
           @log_t = Time.new
           @log_s  <<  "[%02d:%02d:%02d]\t%s\n" % [ @log_t.hour, @log_t.min, @log_t.sec, n ] 
           return 0
        else
           return @log_s.join
        end
    end

    def write
        if @s_lengh < @log_s.count
            @f << @log_s[@s_lengh..@log_s.count].join
            @f.flush
            @s_lengh = @log_s.count
        end
    end
    
    def update_file
        @f.close
        log_open
    end
end
