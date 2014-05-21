require 'spec_helper'

describe FlatFile::Parser do
  before(:each) do
    @definition = mock('definition', sections: [])
    @file = mock('file')
end
