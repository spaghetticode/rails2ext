require 'spec_helper'

class Person < ActiveRecord::Base
  establish_connection :adapter => 'sqlite3', :database => ':memory:'
  connection.create_table table_name, :force => true do |t|
    t.string :name
  end
end

describe FirstOrCreate do
  before { Person.delete_all }

  context 'when no record matches given attributes' do
    context 'when attributes are valid' do
      let(:attributes) { {:name => 'Joe'} }

      it 'should create a new record' do
        expect do
          Person.first_or_create!(attributes)
        end.to change(Person, :count).by(1)
      end

      it 'created record should have requested attributes' do
        Person.first_or_create!(attributes)
        Person.find_by_name(attributes[:name]).should_not be_nil
      end
    end

    context 'when attributes are not valid' do
      let(:attributes) { {:surname => 'Doe'} }

      it 'should raise an error' do
        expect do
          Person.first_or_create!(attributes)
        end.to raise_error(ActiveRecord::StatementInvalid)
      end
    end
  end

  context 'when a record matches given attributes' do
    before do
      @attributes = {:name => 'Joe'}
      @joe = Person.create!(@attributes)
    end

    it 'should return that record' do
      Person.first_or_create!(@attributes).should == @joe
    end

    it 'should not create a new record' do
      expect do
        Person.first_or_create!(@attributes)
      end.to_not change(Person, :count)
    end
  end
end