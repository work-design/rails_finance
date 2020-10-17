require 'test_helper'
class Finance::Admin::FundBudgetsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @finance_admin_fund_budget = create finance_admin_fund_budgets
  end

  test 'index ok' do
    get admin_fund_budgets_url
    assert_response :success
  end

  test 'new ok' do
    get new_admin_fund_budget_url
    assert_response :success
  end

  test 'create ok' do
    assert_difference('FundBudget.count') do
      post admin_fund_budgets_url, params: { #{singular_table_name}: { #{attributes_string} } }
    end

    assert_response :success
  end

  test 'show ok' do
    get admin_fund_budget_url(@finance_admin_fund_budget)
    assert_response :success
  end

  test 'edit ok' do
    get edit_admin_fund_budget_url(@finance_admin_fund_budget)
    assert_response :success
  end

  test 'update ok' do
    patch admin_fund_budget_url(@finance_admin_fund_budget), params: { #{singular_table_name}: { #{attributes_string} } }
    assert_response :success
  end

  test 'destroy ok' do
    assert_difference('FundBudget.count', -1) do
      delete admin_fund_budget_url(@finance_admin_fund_budget)
    end

    assert_response :success
  end

end
