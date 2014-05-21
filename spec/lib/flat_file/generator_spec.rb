require 'spec_helper'

describe FlatFile::Generator do
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
    @data = {
      header: [{ type: 'HEAD', file_id: '1' }],
      body: [
        { first: 'Dennis', last: 'Rodman' },
        { first: 'Scottie', last: 'Pippen' }
      ],
      footer: [{ type: 'FOOT', file_id: '1' }]
    }
    @generator = FlatFile::Generator.new(@definition)
  end

  it 'should raise an error if there is no data for a required section' do
    @data.delete :header
    -> { @generator.generate(@data) }.should raise_error(
      FlatFile::RequiredSectionEmptyError,
      "Required section 'header' was empty."
    )
  end

  it 'should generate a string' do
    expected = "HEAD1         \nDennis    Rodman    \nScottie   Pippen    \nFOOT1         "
    @generator.generate(@data).should == expected
  end

  it 'should handle lazy data declaration (no array around single record for a section)' do
    expected = "HEAD1         \nDennis    Rodman    \nScottie   Pippen    \nFOOT1         "
    @data[:header] = @data[:header].first
    @generator.generate(@data).should == expected
  end
end
