module ContestsHelper
  def print_creator(contest)
    user = contest.user
    return link_to(user.name, user_path(user)) unless user.guest?
    return user.name
  end
end
