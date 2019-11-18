class Finance::My::BaseController < RailsFinance.config.my_controller.constantize

  default_form_builder 'FinanceMyFormBuilder' do |config|
    config.css.label = 'three wide field'
    config.css.offset = 'three wide field'
  end
  
end
