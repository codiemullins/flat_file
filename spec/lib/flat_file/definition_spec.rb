require 'spec_helper'

describe FlatFile::Definition do
  describe 'when specifying alignment' do
    it 'should have an alignment option' do
      d = FlatFile::Definition.new align: :right
      d.options[:align].should == :right
    end

    it 'should default to being left aligned' do
      d = FlatFile::Definition.new
      d.options[:align].should == :left
    end

    it 'should override the default if :align is passed to the section' do
      section = double('section').as_null_object
      FlatFile::Section.should_receive(:new).with('name', {align: :right}).and_return(section)
      d = FlatFile::Definition.new
      d.options[:align].should == :left
      d.section('name', align: :right) {}
    end
  end

  describe 'when creating a section' do
    before(:each) do
      @d = FlatFile::Definition.new
      @section = double('section').as_null_object
    end

    it 'should create and yield a new section object' do
      yielded = nil
      @d.section :header do |section|
        yielded = section
      end
      yielded.should be_a(FlatFile::Section)
      @d.sections.first.should == yielded
    end

    it 'should build a section from an unknown method' do
      FlatFile::Section.should_receive(:new).with(:header, anything()).and_return(@section)
      @d.header {}
    end

    it 'should not create duplicate section names' do
      lambda = -> { @d.section(:header) {} }
      lambda.should_not raise_error
      lambda.should raise_error(FlatFile::DuplicateSectionNameError,  "Duplicate section name: 'header'")
    end
  end
end
