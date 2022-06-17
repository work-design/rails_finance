module Finance
  class Fund < ApplicationRecord
    include Model::Fund
    include Trade::Ext::Sell if defined? RailsTrade
  end
end
