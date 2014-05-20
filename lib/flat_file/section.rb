module FlatFile
  class Section
    attr_accessor :definition
    attr_reader :name, :columns, :options

    def initialize(name, options = {})
      @name = name
      @options = options
      @columns = []
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
  end
end
