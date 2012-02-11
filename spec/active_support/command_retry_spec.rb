require 'spec_helper'

describe CommandRetry do
  describe '#retry' do
    context 'when command is successful' do
      it 'should raise no error' do
        command = CommandRetry.new {system 'echo'}
        lambda {command.retry}.should_not raise_error
      end
    end

    context 'when command is not successful' do
      it 'should raise an error' do
        command = CommandRetry.new {system 'will fail'}
        lambda {command.retry}.should raise_error(RuntimeError)
      end

      context 'when providing "times" option' do
        subject { CommandRetry.new(:times => 5) {system 'will fail'} }

        it 'should repeat operation, if not successful' do
          subject.expects(:exit_status).times(5).returns(1)
          subject.retry rescue nil
        end
      end

      context 'when providing "fail" option' do
        context 'when "fail" is a class' do
          subject { CommandRetry.new(:fail => ArgumentError) {system 'will fail'} }

          it 'should raise expected error' do
            lambda {subject.retry}.should raise_error(ArgumentError)
          end
        end

        context 'when "fail" is set to false' do
          subject { CommandRetry.new(:fail => false) {system 'will fail'} }

          it 'should raise no error' do
            lambda {subject.retry}.should_not raise_error
          end
        end
      end

      context 'when providing "on" option' do
        subject { CommandRetry.new(:on => 42, :times => 3) {system 'will fail'} }

        it 'should retry for given exit codes' do
          subject.expects(:exit_status).times(3).returns(42)
          subject.retry rescue nil
        end

        it 'should not raise error for other exit codes' do
          subject.expects(:exit_status).times(1).returns(1)
          lambda {subject.retry}.should_not raise_error
        end

        it 'should not retry for other exit codes' do
          subject.expects(:exit_status).times(1).returns(1)
          subject.retry
        end
      end
    end
  end

  describe '::retry' do
    it 'should wrap initialization and retry process' do
      CommandRetry.any_instance.expects(:retry)
      CommandRetry.retry(:fail => false) {system 'ls'}
    end
  end
end