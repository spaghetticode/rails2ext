require 'spec_helper'

describe FirstOrCreate do
  it 'ActiveRecord::Base children classes should respond to find_or_create!' do
    class Sample < ActiveRecord::Base; end
    Sample.should respond_to('first_or_create!')
  end

  it 'add specs!'
end