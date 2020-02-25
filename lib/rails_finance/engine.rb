module RailsFinance
  class Engine < ::Rails::Engine

    config.autoload_paths += Dir[
      "#{config.root}/app/models/expense"
    ]

  end
end
