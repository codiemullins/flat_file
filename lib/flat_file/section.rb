module FlatFile
  class Section
    attr_accessor :definition, :optional, :singular
    attr_reader :name, :columns, :options

    def initialize(name, options = {})
      @name     = name
      @options  = options
      @columns  = []
      @trap     = options[:trap]
      @optional = options[:optional] || false
      @singular = options[:singular] || false
    end

    def column(name, length, options = {})
      if name != :spacer && @columns.find { |c| c.name == name }
        raise FlatFile::DuplicateColumnNameError.new("You have already defined a column named '#{name}'.")
      end

      col = Column.new(name, length, @options.merge(options))
      @columns << col
      col
    end

    def spacer(length, spacer = nil)
      options = {}
      options[:padding] = spacer if spacer
      column(:spacer, length, options)
    end

    def trap(&block)
      @trap = block
    end

    def format(data)
      @columns.map do |c|
        c.format data[c.name]
      end.join
    end

    def parse(line)
      row = {}
      cursor = 0
      @columns.each do |column|
        unless column.name == :spacer
          pos_length_end = cursor + column.length - 1
          value = line[cursor..pos_length_end] || ''
          row[column.name] = column.parse(value)
        end
        cursor += column.length
      end

      row
    end

    def match(raw_line)
      raw_line.nil? ? false : @trap.call(raw_line)
    end

    def method_missing(method, *args)
      column(method, *args)
    end
  end
end
