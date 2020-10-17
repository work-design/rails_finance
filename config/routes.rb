Rails.application.routes.draw do

  scope :admin, module: 'finance/admin', as: :admin do
    resources :financial_taxons
    resources :funds do
      resources :fund_incomes
      resources :fund_expenses
      resources :fund_budgets
    end
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
        match :financial_taxons, via: [:get, :post]
        get :add_item
        get :remove_item
        get :admin
      end
      member do
        patch :transfer
        patch :submit
      end
    end
    resources :expenses do
      collection do
        get :financial_taxons
        get :add_item
        get :remove_item
        get :add_member
        get :remove_member
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
