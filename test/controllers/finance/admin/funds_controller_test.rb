require 'test_helper'
class Finance::Admin::FundsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @finance_admin_fund = create finance_admin_funds
  end

  test 'index ok' do
    get admin_funds_url
    assert_response :success
  end

  test 'new ok' do
    get new_admin_fund_url
    assert_response :success
  end

  test 'create ok' do
    assert_difference('Fund.count') do
      post admin_funds_url, params: { #{singular_table_name}: { #{attributes_string} } }
    end

    assert_response :success
  end

  test 'show ok' do
    get admin_fund_url(@finance_admin_fund)
    assert_response :success
  end

  test 'edit ok' do
    get edit_admin_fund_url(@finance_admin_fund)
    assert_response :success
  end

  test 'update ok' do
    patch admin_fund_url(@finance_admin_fund), params: { #{singular_table_name}: { #{attributes_string} } }
    assert_response :success
  end

  test 'destroy ok' do
    assert_difference('Fund.count', -1) do
      delete admin_fund_url(@finance_admin_fund)
    end

    assert_response :success
  end

end
