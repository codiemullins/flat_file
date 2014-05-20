module FlatFile
  class Generator
    def initialize(context)
      @context = context
    end

    def generate(data)
      @builder = []
      puts @context.types
    end
  end
end
