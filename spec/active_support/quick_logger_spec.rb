require 'spec_helper'

describe QuickLogger do
  class TestLogger < QuickLogger; end

  it 'should have filename accessor' do
    filename = 'something_else'
    TestLogger.filename = filename
    TestLogger.filename.should == filename
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