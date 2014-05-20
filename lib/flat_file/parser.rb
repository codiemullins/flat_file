module FlatFile
  class Parser
    attr_accessor :definition, :file

    def initialize(defintiion, file)
      @definition = definition
      @file = file
    end
  end
end
