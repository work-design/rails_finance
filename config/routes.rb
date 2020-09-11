Rails.application.routes.draw do

  scope :admin, module: 'finance/admin', as: :admin do
    resources :financial_taxons
    resources :expense_members, only: [] do
      get :my, on: :collection
    end
    resources :expenses do
      get :my, on: :collection
      member do
        patch :next
        patch :trigger
      end
      resources :expense_members, shallow: true do
        member do
          patch :to_pay
          patch :to_advance_pay
        end
      end
    end
  end

  scope :me, module: 'finance/me', as: :me do
    resources :expenses do
      post :financial_taxons, on: :collection
      get 'add_item/:item' => :add_item, on: :collection, as: :add_item
      get 'remove_item/:item' => :remove_item, on: :collection, as: :remove_item
      member do
        patch :transfer
        get :confirm
        patch :requested
        get :bill
      end
    end
    resources :expense_members, only: [:index, :show, :edit, :update] do
      member do
        get :bill
        get :items
      end
    end
  end

end
