module FinanceController::Me
  extend ActiveSupport::Concern

  class_methods do
    def local_prefixes
      [controller_path, 'finance/me/base', 'me']
    end
  end

end
