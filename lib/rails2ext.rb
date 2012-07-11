module Rails2ext
  require 'active_support/all'
  require 'active_record'
  %w[active_support active_record].each do |filename|
    require File.expand_path "../rails2ext/#{filename}", __FILE__
  end
end
