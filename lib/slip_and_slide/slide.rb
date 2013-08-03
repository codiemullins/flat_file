class Slide < SlipAndSlide
  
  class << self
    def create_context
      SlideContext.new
    end
    
    def parse_line line, context
      line.split context.separator
    end
  end
  
  private
  
  class SlideContext
    attr_accessor :types, :lines_to_skip
    
    def initialize
      @types = {}
      @lines_to_skip = 0
      @separator = ","
    end
    
    def column(name, options={})
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
