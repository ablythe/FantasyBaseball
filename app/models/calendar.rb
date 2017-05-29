class Calendar

  def self.month_first_day month
    if month == 4
      return 5
    else
      return 1
    end
  end

  def self.month_last_day month
    if [4,6,9].include? month
      return 30
    elsif [5,7,8].include? month
      return 31
    else
      return 4
    end
  end


end
