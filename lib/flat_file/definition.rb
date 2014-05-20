module FlatFile
  class Definition
    attr_reader :sections, :options

    def initialize(options = {})
      @sections = []
      @options  = { align: :left }.merge(options)
    end

    def section(name, options = {}, &block)
      if @sections.find { |s| s.name == name }
        raise DuplicateSectionNameError.new("Duplicate section name: '#{name}'")
      end

      section = FlatFile::Section.new(name, @options.merge(options))
      section.definition = self
      yield(section)
      @sections << section
      section
    end

    def method_missing(method, *args, &block)
      section(method, *args, &block)
    end
  end
end
