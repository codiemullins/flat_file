class SlipAndSlide
  cattr_accessor(:formats) { Hash.new }
  
  class << self
    def define(name, &block)
      context = create_context
      context.instance_eval &block
      formats[name] = context
    end
    
    def parse(file_name, name)
      results = []
      context = formats[name]
      count = 0
      file_io = File.open(file_name, 'r')
      file_io.each_line do |line| 
        count += 1
        next unless count > context.lines_to_skip
        result = create_hash(line, context)
        results.push type_fixer(result, context.types)
      end

      results
    end
    
    private 
    
    def create_hash(line, context)
      values = parse_line line, context
      keys = context.types.keys
      Hash[keys.zip(values)]
    end
    
    def type_fixer(hash, types)
      types.each do |name, options|
        case options[:type]
        when :date
          hash[name] = Date.parse(hash[name].strip) if hash[name].present?
        when :float
          hash[name] = hash[name].to_f
        else
          hash[name].strip!
        end
      end
      hash
    end
    
  end
end

require 'slip_and_slide/slip'
require 'slip_and_slide/slide'
