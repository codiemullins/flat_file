require 'spec_helper'

describe FlatFile::Parser do
  before(:each) do
    @definition = double('definition', sections: [])
    @file = double('file')
    @parser = FlatFile::Parser.new(@definition, @file)
  end

  it 'should read in a source file' do
    @file.should_receive(:readlines).and_return(["\n"])
    @parser.parse
  end

  describe 'when parsing sections' do
    before(:each) do
      @definition = FlatFile::define :test do |d|
        d.header do |h|
          h.trap { |line| line[0, 4] == 'HEAD' }
          h.column :type, 4
          h.column :file_id, 10
        end
        d.body do |b|
          b.trap { |line| line[0, 4] =~ /[^(HEAD|FOOT)]/ }
          b.column :first, 10
          b.column :last, 10
        end
        d.footer do |f|
          f.trap { |line| line[0, 4] == 'FOOT' }
          f.column :type, 4
          f.column :file_id, 10
        end
      end
      @parser = FlatFile::Parser.new(@definition, @file)
    end

    it 'should add lines to the proper sections' do
      @file.should_receive(:readlines).and_return([
        "HEAD1         \n",
        "Dennis    Rodman    \n",
        "Scottie   Pippen    \n",
        "FOOT1         \n"
      ])
      expected = {
        header: [{ type: 'HEAD', file_id: '1' }],
        body: [
          { first: 'Dennis', last: 'Rodman' },
          { first: 'Scottie', last: 'Pippen' }
        ],
        footer: [{ type: 'FOOT', file_id: '1' }]
      }
      result = @parser.parse
      result.should == expected
    end

    it 'should treat singular sections properly' do
      @definition = FlatFile::define :test do |d|
        d.header(singular: true) do |h|
          h.trap { |line| line[0, 4] == 'HEAD' }
          h.column :type, 4
          h.column :file_id, 10
        end
        d.body do |b|
          b.trap { |line| line[0, 4] =~ /[^(HEAD|FOOT)]/ }
          b.column :first, 10
          b.column :last, 10
        end
        d.footer(singular: true) do |f|
          f.trap { |line| line[0, 4] == 'FOOT' }
          f.column :type, 4
          f.column :file_id, 10
        end
      end
      @parser = FlatFile::Parser.new(@definition, @file)
      @file.should_receive(:readlines).and_return([
        "HEAD1         \n",
        "Dennis    Rodman    \n",
        "Scottie   Pippen    \n",
        "FOOT1         \n"
      ])
      expected = {
        header: { type: 'HEAD', file_id: '1' },
        body: [
          { first: 'Dennis', last: 'Rodman' },
          { first: 'Scottie', last: 'Pippen' }
        ],
        footer: { type: 'FOOT', file_id: '1' }
      }
      result = @parser.parse
      result.should == expected
    end

    it 'should allow optional sections to be skipped' do
      @definition.sections[0].optional = true
      @definition.sections[2].optional = true
      @file.should_receive(:readlines).and_return([
        "Dennis    Rodman    \n"
      ])
      expected = { body: [{ first: 'Dennis', last: 'Rodman' }] }
      @parser.parse.should == expected
    end

    it 'should raise an error if a required section is not found' do
      @file.should_receive(:readlines).and_return([
        "Dennis    Rodman    \n"
      ])
      -> { @parser.parse }.should raise_error(
        FlatFile::RequiredSectionNotFoundError,
        "Required section 'header' was not found."
      )
    end
  end
end
