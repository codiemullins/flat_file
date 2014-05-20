module FlatFile
  class << self
    attr_accessor :options

    def define(name, options = {})
      definition = Definition.new(options)
      @options = options
      yield(definition)
      definitions[name] = definition
      definition
    end

    def generate(definition_name, data)
      definition = definition(definition_name)
      unless definition
        raise ArgumentError.new("Definition name '#{name}' was not found.")
      end
      generator = Generator.new(definition)
      generator.generate(data)
    end

    def parse(file, definition_name)
      definition = definition(definition_name)
      unless definition
        raise ArgumentError.new "Definition name '#{definition_name}' was not found."
      end
      parser = Parser.new(definition, file)
      parser.parse
    end

    def write(file, definition_name, data)
      file.write(generate(definition_name, data))
    end

    def definitions
      @@definitions ||= {}
    end

    def definition(name)
      definitions[name]
    end
  end
end
