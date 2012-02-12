require 'logger'

# quick and dirty logger: just inherit from here,
# set the filename attribute then you're ready to go
class QuickLogger
  class << self
    attr_accessor :filename

    def filename_path
      if defined?(Rails)
        File.join Rails.root, 'log', [@filename, Rails.env, 'log'].join('.')
      else
        [@filename, 'log'].join('.')
      end
    end

    def method_missing(log_level, message)
      @logger ||= ::Logger.new(filename_path)
      if ::Logger::SEV_LABEL.include?(log_level.to_s.upcase)
        @logger.send log_level, "[#{Time.now}] #{message}"
      else
        super
      end
    end
  end
end

# keep legacy interface
module Quick
  class Logger < QuickLogger
  end
end
