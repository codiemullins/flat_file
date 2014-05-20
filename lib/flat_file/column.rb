module FlatFile
  class Column
    DEFAULT_PADDING = ' '
    DEFAULT_TRUNCATE = false
    DEFAULT_FORMATTER = :to_s
    DEFAULT_ALIGNMENT = :left

    attr_accessor :name, :length, :padding, :truncate

    def initialize(name, length, options = {})
      @name = name
      @length = length

      @static = options[:static] || nil

      @alignment = options[:align]    || DEFAULT_ALIGNMENT
      @padding   = options[:padding]  || DEFAULT_PADDING
      @truncate  = options[:truncate] || DEFAULT_TRUNCATE

      @parser = options[:parser]
      @parser = @parser.to_proc if @parser.is_a?(Symbol)

      @formatter = options[:formatter] || DEFAULT_FORMATTER
      @formatter = @formatter.to_proc if @formatter.is_a?(Symbol)
    end

    def parse(value = @static)
      if @parser
        @parser.call(value)
      else
        value.strip.gsub(/\t/, '')
      end
    end

    def format(value = @static)
      pad(validate_size(@formatter.call(value)))
    end

    private

    def pad(value = @static)
      case @alignment
      when :left then value.ljust(@length, @padding)
      when :right then value.rjust(@length, @padding)
      end
    end

    def validate_size(result)
      return result if result.length <= @length
      unless @truncate
        raise FlatFile::FormattedStringExceedsLengthError.new(
          "The formatted value '#{result}' in column '#{@name}' exceeds the allowed length of #{@length} chararacters.")
      end
      case @alignment
      when :right then result[-@length, @length]
      when :left then result[0, @length]
      end
    end
  end
end
