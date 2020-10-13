require 'test_helper'
class Finance::Admin::FundIncomesControllerTest < ActionDispatch::IntegrationTest

  setup do
    @finance_admin_fund_income = create finance_admin_fund_incomes
  end

  test 'index ok' do
    get admin_fund_incomes_url
    assert_response :success
  end

  test 'new ok' do
    get new_admin_fund_income_url
    assert_response :success
  end

  test 'create ok' do
    assert_difference('FundIncome.count') do
      post admin_fund_incomes_url, params: { #{singular_table_name}: { #{attributes_string} } }
    end

    assert_response :success
  end

  test 'show ok' do
    get admin_fund_income_url(@finance_admin_fund_income)
    assert_response :success
  end

  test 'edit ok' do
    get edit_admin_fund_income_url(@finance_admin_fund_income)
    assert_response :success
  end

  test 'update ok' do
    patch admin_fund_income_url(@finance_admin_fund_income), params: { #{singular_table_name}: { #{attributes_string} } }
    assert_response :success
  end

  test 'destroy ok' do
    assert_difference('FundIncome.count', -1) do
      delete admin_fund_income_url(@finance_admin_fund_income)
    end

    assert_response :success
  end

end
