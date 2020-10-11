Rails.application.routes.draw do

  scope :admin, module: 'finance/admin', as: :admin do
    resources :financial_taxons
    resources :budgets
    resources :expenses do
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
    resources :budgets do
      collection do
        get 'add_item' => :add_item, as: :add_item
        get 'remove_item' => :remove_item, as: :remove_item
      end
      member do
        patch :transfer
      end
    end
    resources :expenses do
      collection do
        post :financial_taxons
        get :admin
      end
      member do
        get :confirm
        patch :requested
        get :bill
      end
    end
    resources :expense_members, only: [:index, :show, :edit, :update] do
      collection do
        get :admin
      end
      member do
        get :bill
        get :items
      end
    end
  end

end
