class Calendar

  def self.month_first_day month
    if month == 4 
      return 5
    else
      return 1
    end
  end

  def self.month_last_day month
    if month == 4 || month == 6 || month == 9
      return 30
    elsif month == 5 || month = 7 || month == 8
      return 31
    elsif month == 10
      return 4
    end
  end


end