# CommandRetry helps you repeat system commands when they
# are not successful for a given number of times (repeat
# once by default).
# If all repetitions fail, an error (default is
# RuntimeError) will be raised unless you passed in
# +:fail => false+ option
#
# It accepts also a +on+ option, which can be a single
# exit code or an array of exit codes that will cause
# the block to be repeated.
# Other exit codes not included in the +on+ array (if
# provided) will not cause repetitions and will will
# not raise errors.
#
# Will retry 5 times, failing each time and eventually
# raise the default error:
#
#   CommandRetry.retry(:times => 5) { system 'bingobongo' }
#   #=> RuntimeError: #<RuntimeError:0x101d89648>
#
# Will fail 5 times with exit code 7, eventually will
# raise custom error:
#
#   CommandRetry.retry(:fail => ArgumentError, :on => 7 :times => 5) do
#     system 'curl localhost:123/notfound'
#   end
#
# Will fail just once since exit code 7 is not
# included in +on+ array, and will raise no error:
#
#   CommandRetry.retry(:on => 52, :times => 5) do
#     system 'curl localhost:123/notfound'
#   end

class CommandRetry
  def self.retry(opts={}, &block)
    new(opts, &block).retry
  end

  def initialize(opts={}, &block)
    opts.symbolize_keys!
    @times   = opts[:times] || 2
    @fail    = opts[:fail]  || RuntimeError unless opts[:fail] == false
    @on      = Array.wrap(opts[:on]) if opts[:on]
    @command = block
  end

  def retry
    result = false
    status = 0
    @times.times do
      result = @command.call
      status = exit_status
      if should_break?(status)
        break
      end
    end

    if @fail && status != 0
      unless on_allows?(status)
        raise @fail, caller
      end
    end
    result
  end

  private

  def exit_status
    $?.exitstatus
  end

  def should_break?(status)
    status.zero? or on_allows?(status)
  end

  def on_allows?(status)
    @on && !@on.include?(status)
  end
end