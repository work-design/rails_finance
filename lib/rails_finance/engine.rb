require 'rails_com'
module RailsFinance
  class Engine < ::Rails::Engine

    config.autoload_paths += Dir[
      "#{config.root}/app/models/expense",
      "#{config.root}/app/models/budget"
    ]

    config.generators do |g|
      g.rails = {
        assets: false,
        stylesheets: false,
        helper: false,
        resource_route: false,
        jbuilder: true
      }
      g.test_unit = {
        fixture: true,
        fixture_replacement: :factory_girl
      }
      g.templates.unshift File.expand_path('lib/templates', RailsCom::Engine.root)
    end

  end
end
