
class Log
    def initialize
        @tname = Time.new
        @fname = "plurbybot-%04d%02d%02d.log" % [ @tname.year, @tname.mon, @tname.day]
        @f = File.new(@fname,"a+")
        @log_s = []
    end
#作為背景資訊緩衝 -- 對應指令 log
    def logger( n = nil )
        if n
           @log_t = Time.new
           @log_s  <<  "[%02d:%02d:%02d]\t" % [ @log_t.hour, @log_t.min, @log_t.sec ] 
           return 0
        else
           return @log
        end
    end
    def write
        if @log_s
            @log = @log_s
            @log_s = @log.pop 20
            @f.write(@log)
            @log = nil
        end
    end
end
