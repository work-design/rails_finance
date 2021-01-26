module Finance
  class Fund < ApplicationRecord
    include Model::Fund
    include Trade::Model::Sell if defined? RailsTrade
  end
end
