class Finance::My::BaseController < RailsFinance.config.my_controller.constantize

  def current_member
    Member.first
  end

end
