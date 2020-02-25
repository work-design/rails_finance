Rails.application.routes.draw do

  scope :finance, module: 'finance/admin', as: 'admin' do
    resources :financial_taxons
    resources :expense_members, only: [] do
      get :my, on: :collection
    end
    resources :expenses do
      get :my, on: :collection
      patch :next, on: :member
      patch :trigger, on: :member
      resources :expense_members, shallow: true do
        patch :to_pay, on: :member
        patch :to_advance_pay, on: :member
      end
    end
  end

  scope :my, module: 'finance/my', as: 'my' do
    resources :expenses do
      post :financial_taxons, on: :collection
      get 'add_item/:item' => :add_item, on: :collection, as: :add_item
      get 'remove_item/:item' => :remove_item, on: :collection, as: :remove_item
      patch :transfer, on: :member
      get :confirm, on: :member
      patch :requested, on: :member
      get :bill, on: :member
    end
    resources :expense_members, only: [:index, :show, :edit, :update] do
      get :bill, on: :member
      get :items, on: :member
    end
  end

end
