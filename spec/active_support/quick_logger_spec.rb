require 'spec_helper'

describe QuickLogger do
  class TestLogger < QuickLogger; end
  context 'when explicitly setting the filename' do
    it 'should set filename value as expected' do
      filename = 'something_else'
      TestLogger.filename = filename
      TestLogger.filename.should == filename
    end
  end

  context 'when no explicit filename is set' do
    it 'has default filename' do
      TestLogger.instance_variable_set '@filename', nil
      QuickLogger.filename.should == QuickLogger::DEFAULT_FILENAME
    end
  end

  describe 'filename_path' do
    context 'when extending a rails app' do
      before do
        unless defined?(Rails)
          module Rails; end
        end
        Rails.stubs(:env => 'test', :root => '/rails/rootpath')
      end

      it 'should be in log dir, include rails env, have log extension' do
        TestLogger.filename = 'some/path'
        TestLogger.filename_path.should == '/rails/rootpath/log/some/path.test.log'
      end
    end

    context 'when used alone' do
      before do
        Object.send(:remove_const, :Rails) if defined?(Rails)
      end

      it 'should match the plain filename' do
        TestLogger.filename = 'other/path'
        TestLogger.filename_path.should == 'other/path.log'
      end
    end
  end

  it 'should respond to classic logger methods' do
    lambda do
      TestLogger.info "message"
    end.should_not raise_error(NameError)
  end
end
