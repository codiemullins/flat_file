class Slip < SlipAndSlide
  
  class << self  
    def create_context
      SlipContext.new
    end
    
    def parse_line line, context
      line.unpack context.format
    end
  end
  
  private
  
  class SlipContext
    attr_accessor :types, :lines_to_skip, :format
    
    def initialize
      @format = ""
      @types = {}
      @lines_to_skip = 0
    end
    
    def column(name, size, options={})
      @format += "A#{size}"
      @types[name] = options
    end
    
    def ignore_lines(lines_to_skip)
      @lines_to_skip = lines_to_skip
    end
    
    def separator(delimiter = nil)
      delimiter.nil? ? @separator : @separator = delimiter
    end
    
  end
  
end
