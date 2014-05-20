require 'spec_helper'

describe FlatFile do

  before(:each) do
    @name = :doc
    @options = { type: :fixed }
  end

  describe 'when defining a format' do
    before(:each) do
      @definition = double('definition')
    end
  end

  it 'should create a new definition using the specified name and options' do
    FlatFile.should_receive(:define).with(@name, @options).and_return(@definition)
    FlatFile.define(@name, @options)
  end

  it 'should pass the definition to the block' do
    yielded = nil
    FlatFile.define(@name) do |y|
      yielded = y
    end
    yielded.should be_a(FlatFile::Definition)
  end

  it 'should add to the internal definition count' do
    FlatFile.definitions.clear
    FlatFile.should have(0).definitions
    FlatFile.define(@name, @options) {}
    FlatFile.should have(1).definitions
  end

  describe 'when creating file from data' do
    it 'should raise an error if the definition name is not found' do
      -> { FlatFile.generate(:not_there, {}) }.should raise_error(ArgumentError)
    end

    it 'should output a string' do
      definition = double('definition')
      generator = double('generator')
      generator.should_receive(:generate) {}
      FlatFile.should_receive(:definition).with(:test).and_return(definition)
      FlatFile::Generator.should_receive(:new).with(definition).and_return(generator)
      FlatFile.generate(:test, {})
    end

    it 'should output a file' do
      file = double('file')
      text = double('string')
      file.should_receive(:write).with(text)
      FlatFile.should_receive(:generate).with(:test, {}).and_return(text)
      FlatFile.write(file, :test, {})
    end
  end

  describe 'when parsing a file' do
    before(:each) do
      @file = double('file')
    end

    it 'should check the file exists' do
      -> { FlatFile.parse(@file, :doc, {}) }.should raise_error(ArgumentError)
    end

    it 'should raise an error if the definition name is not found' do
      FlatFile.definitions.clear
      -> { FlatFile.parse(@file, :test, {}) }.should raise_error(ArgumentError)
    end

    it 'should create a parser and call parse' do
      parser = double('parser').as_null_object
      definition = double('definition')
      FlatFile.should_receive(:definition).with(:doc).and_return(definition)
      FlatFile::Parser.should_receive(:new).with(definition, @file).and_return(parser)
      FlatFile.parse(@file, :doc)
    end
  end
end
