require 'test_helper'
class Finance::Admin::FundUsesControllerTest < ActionDispatch::IntegrationTest

  setup do
    @finance_admin_fund_use = create finance_admin_fund_uses
  end

  test 'index ok' do
    get admin_fund_uses_url
    assert_response :success
  end

  test 'new ok' do
    get new_admin_fund_use_url
    assert_response :success
  end

  test 'create ok' do
    assert_difference('FundUse.count') do
      post admin_fund_uses_url, params: { #{singular_table_name}: { #{attributes_string} } }
    end

    assert_response :success
  end

  test 'show ok' do
    get admin_fund_use_url(@finance_admin_fund_use)
    assert_response :success
  end

  test 'edit ok' do
    get edit_admin_fund_use_url(@finance_admin_fund_use)
    assert_response :success
  end

  test 'update ok' do
    patch admin_fund_use_url(@finance_admin_fund_use), params: { #{singular_table_name}: { #{attributes_string} } }
    assert_response :success
  end

  test 'destroy ok' do
    assert_difference('FundUse.count', -1) do
      delete admin_fund_use_url(@finance_admin_fund_use)
    end

    assert_response :success
  end

end
