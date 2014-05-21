module FlatFile
  class Parser
    attr_accessor :definition, :file

    def initialize(definition, file)
      @definition = definition
      @file = file
    end

    def parse
      @parsed = {}
      @content = read_file

      unless @content.empty?
        definition.sections.each do |section|
          rows = fill_content(section)
          unless rows > 0 || section.optional
            raise FlatFile::RequiredSectionNotFoundError.new(
              "Required section '#{section.name}' was not found."
            )
          end
        end
      end

      @parsed
    end

    private

    def read_file
      @file.readlines.map(&:chomp)
    end

    def fill_content(section)
      matches = 0
      loop do
        line = @content.first
        break unless section.match(line)
        add_to_section(section, line)
        matches += 1
        @content.shift
      end
      matches
    end

    def add_to_section(section, line)
      if section.singular
        @parsed[section.name] = section.parse(line)
      else
        @parsed[section.name] ||= []
        @parsed[section.name] << section.parse(line)
      end
    end
  end
end
