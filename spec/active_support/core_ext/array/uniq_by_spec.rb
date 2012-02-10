require 'spec_helper'

describe Array do
  describe '#uniq_by' do
    it 'should return an array' do
      [].uniq_by {}.should be_an(Array)
    end

    it 'should return unique values' do
      [1, 2, 3, 4].uniq_by { |i| i.odd? }.should == [1, 2]
    end
  end
end