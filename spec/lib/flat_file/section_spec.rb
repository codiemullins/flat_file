require 'spec_helper'

describe FlatFile::Section do
  before(:each) do
    @section = FlatFile::Section.new(:body)
  end

  it 'should have no columns after creation' do
    @section.columns.should be_empty
  end

  it 'should have a name' do
    @section.name.should == :body
  end

  describe 'when adding columns' do
    it 'should build an ordered column list' do
      @section.should have(0).columns

      col1 = @section.column :id, 10
      col2 = @section.column :name, 30
      col3 = @section.column :state, 2

      @section.should have(3).columns
    end

    it 'should create spacer columns' do
      @section.should have(0).columns
      @section.spacer(5)
      @section.should have(1).columns
    end

    it 'should prevent duplicate column names' do
      @section.column :id, 10
      -> { @section.column(:id, 30) }.should raise_error(FlatFile::DuplicateColumnNameError, /column named 'id'/)
    end

    it 'should allow duplicate column names that are reserved (i.e. spacer)' do
      @section.spacer 10
      -> { @section.spacer 30 }.should_not raise_error
    end
  end

  describe 'when formatting a row' do
    before(:each) do
      @data = { id: 3, name: 'Bobby' }
    end

    it 'should support dynamic method names as columns' do
      @section.transaction_id(8)
      @section.format(transaction_id: '1234').should == '1234    '
    end

    it 'should default to string data aligned left' do
      @section.column(:id, 5)
      @section.column(:name, 10)
      @section.format(@data).should == '3    Bobby     '
    end

    it 'should right align if asked' do
      @section.column(:id, 5, align: :right)
      @section.column(:name, 10)
      @section.format(@data).should == '    3Bobby     '
    end
  end

  describe 'when parsing a file' do
    before(:each) do
      @line = '23 Michael   Jordan    NC'
      @section = FlatFile::Section.new(:body)
      @column_content = { id: 3, first: 10, last: 10, state: 2 }
    end

    it 'should return a key for every key column' do
      @column_content.each { |k, v| @section.column(k, v) }
      parsed = @section.parse(@line)
      @column_content.each_key { |name| parsed.should have_key(name) }
    end

    it 'should not return a key for reserved names' do
      @column_content.each { |k, v| @section.column(k, v) }
      @section.spacer 5
      @section.should have(5).columns
      parsed = @section.parse(@line)
      parsed.should have(4).keys
    end

    it 'should not die if a field is not in range' do
      @section.column(:a, 5)
      @section.column(:b, 5)
      @section.column(:c, 5)
      line = '   45'
      parsed = @section.parse(line)
      parsed[:a].should == '45'
      parsed[:b].should == ''
      parsed[:c].should == ''
    end
  end
end
