class Pitcher
  def self.past_starts_helper month, day, user_id
    user = User.find(user_id)
    count = 0
    month_string = month == 10 ? month : "0#{month}"
    day_string = day >= 10 ? day : "0#{day}"

    count += user.get_days_starts("2017-#{month_string}-#{day_string}")
  end

  def self.started? stats
    stats.first.rstrip == "SP" &&
    stats.last[/-{3,}/] == nil &&
    stats.last.split(',').last[/%0/] == nil
  end
end
