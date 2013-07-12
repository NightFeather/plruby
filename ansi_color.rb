module ANSIC
    CSI = "\33["
    ORG = CSI + "m"
    BLA = 30
    RED = 31
    GRE = 32
    YEL = 33
    BLU = 34
    MAG = 35
    CYN = 36
    WHI = 37
    def ConColor (f=nil, b=nil, s=nil)
        s, f, b = @s, @f, @b
        output = CSI
        if @s
            output += @s.to_s + ';'
        end
        if @f
            output += case @f
                        when "RED" then RED.to_s
                        when "GRE" then GRE.to_s
                        when "YEL" then YEL.to_s
                        when "BLU" then BLU.to_s
                        when "MAG" then MAG.to_s
                        when "CYN" then CYN.to_s
                        when "WHI" then WHI.to_s
                      end
            if @b
                output += case @b
                            when "RED" then "#{RED + 10}"
                            when "GRE" then "#{GRE + 10}"
                            when "YEL" then "#{YEL + 10}"
                            when "BLU" then "#{BLU + 10}"
                            when "MAG" then "#{MAG + 10}"
                            when "CYN" then "#{CYN + 10}"
                            when "WHI" then "#{WHI + 10}"
                          end
            end
        end
        output += 'm'
        return output
    end
end
