require 'spec_helper'

describe FlatFile::Column do
  before(:each) do
    @name = :id
    @length = 7
    @column = FlatFile::Column.new(@name, @length)
  end

  describe 'when being created' do
    it 'should have a name' do
      @column.name.should == @name
    end

    it 'should have a length' do
      @column.length.should == @length
    end

    it 'should have a default padding' do
      @column.padding.should == ' '
    end
  end

  describe 'when specifying padding' do
    before(:each) do
      @column = FlatFile::Column.new(@name, @length, padding: '0')
    end

    it 'should override the default padding' do
      @column.padding.should == '0'
    end
  end

  describe 'when parsing a value from a file' do
    it 'should return empty_string for blank fields' do
      @column.parse('    name ').should == 'name'
      @column.parse('         ').should == ''
      @column.parse("    \t   ").should == ''
      @column.parse('').should == ''
    end

    it 'should support a symbol as the parser (:to_i)' do
      @column = FlatFile::Column.new(:amount, 10, parser: :to_i)
      @column.parse('234       ').should == 234
      @column.parse('23.4      ').should == 23
      @column.parse('Codie     ').should == 0
      @column.parse('00000234  ').should == 234
    end

    it 'should support a symbol as the parser (:to_f)' do
      @column = FlatFile::Column.new(:amount, 10, parser: :to_f)
      @column.parse('234       ').should == 234.0
      @column.parse('23.4      ').should == 23.4
      @column.parse('Codie     ').should == 0.0
      @column.parse('00000234  ').should == 234.0
    end

    it 'should support a lambda as the parser (date)' do
      parser = ->(x) { Date.strptime(x, '%m%d%Y') }
      @column = FlatFile::Column.new(:date, 10, parser: parser)
      dt = @column.parse('05202014')
      dt.should be_a(Date)
      dt.to_s.should == '2014-05-20'
    end
  end

  describe 'when applying formatting options' do
    it 'should respect a static value' do
      @column = FlatFile::Column.new(@name, @length, static: 'static')
      @column.format.should == 'static '
    end

    it 'should respect a right alignment' do
      @column = FlatFile::Column.new(@name, @length, align: :right)
      @column.format(25).should == '     25'
    end
    it 'should respect default padding' do
      @column = FlatFile::Column.new(@name, @length)
      @column.format(25).should == '25     '
    end

    it 'should respect padding with zeros' do
      @column = FlatFile::Column.new(@name, @length, padding: '0')
      @column.format(25).should == '2500000'
    end

    it 'should respect padding with zeros and right alignment' do
      @column = FlatFile::Column.new(@name, @length, align: :right, padding: '0')
      @column.format(25).should == '0000025'
    end
  end

  describe 'when formatting values for a file' do
    it 'should default to a string' do
      @column = FlatFile::Column.new(:name, 10)
      @column.format('John').should == 'John      '
    end

    describe 'whose size is too long' do
      it 'should raise an error if truncate is false' do
        @value = 'XX' * @length
        -> { @column.format(@value) }.should raise_error(
          FlatFile::FormattedStringExceedsLengthError,
          "The formatted value '#{@value}' in column '#{@name}' exceeds the allowed length of #{@length} chararacters."
        )
      end
    end

    describe 'it should support a symbol formattor (:to_s)' do
      @column = FlatFile::Column.new(:amount, 10, formatter: :to_s)
      @column.format(234).should == '234       '
      @column.format('234').should == '234       '
    end
  end
end
