module FirstOrCreate
  def first_or_create!(args)
    find(:first, :conditions => args) || new(args).tap {|record| record.save! }
  end
end