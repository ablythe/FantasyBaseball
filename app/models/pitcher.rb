class Pitcher 


  def self.past_starts_helper month, day, user_id 
    user = User.find(user_id)
    count = 0
    if month == 10
      count += user.get_days_starts("2015-#{month}-0#{day}")
    elsif day < 10 
      count += user.get_days_starts("2015-0#{month}-0#{day}")
    else
      count += user.get_days_starts("2015-0#{month}-#{day}")
    end
    count
  end

  def self.started? stats
    stats.first.rstrip == "SP" && 
    stats.last[/-{3,}/] == nil && 
    stats.last.split(',').last[/%0/] == nil
  end
end