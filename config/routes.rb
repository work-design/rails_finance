Rails.application.routes.draw do
  scope RailsCom.default_routes_scope do
    namespace :finance, defaults: { business: 'finance' } do
      namespace :admin, defaults: { namespace: 'admin' } do
        root 'home#index'
        resources :financial_taxons
        resources :funds do
          resources :fund_incomes
        end
        resources :assessments do
          resources :stocks
        end
        resources :budgets do
          member do
            patch :transfer
          end
        end
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

      namespace :me, defaults: { namespace: 'me' } do
        resources :budgets do
          collection do
            match :financial_taxons, via: [:get, :post]
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
  end
end
