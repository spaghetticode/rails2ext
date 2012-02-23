module FirstOrCreate
  def first_or_create!(args)
    find(:first, :conditions => args) || new(args).save!
  end
end