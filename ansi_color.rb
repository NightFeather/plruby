module AnsiColor
    def colorDef 
        {
            :csi => "\33[",
            :org => "\33[m",
            :bla => 30,
            :red => 31,
            :gre => 32,
            :yel => 33,
            :blu => 34,
            :mag => 35,
            :cyn => 36,
            :whi => 37
        }
    end
    def conColor (f = nil, b = nil, s = nil)
         @s, @f, @b = s, f, b
        output = colorDef[:csi]
        if @s
            output += @s.to_s + ';'
        end
        if @f
            output += colorDef[ @f.to_sym ].to_s
            if @b
                output += ';'
                output += (colorDef [ @b.to_sym]+10).to_s
            end
        end
        output += 'm'
        return output
    end
    def out ( input , hcolor = :gre ,n=1)
        print conColor(hcolor,nil,1) + input.to_s + conColor() + ("\n"*n)
    end
    module_function :colorDef ,:conColor,:out
end

#顏色對應:
#   紅色  Error message
#   綠色  tip 
#   黃色  prompt
#   藍色  (unused)
#   紫色  (unused)
#   青色  general message
#   白色  (unused)