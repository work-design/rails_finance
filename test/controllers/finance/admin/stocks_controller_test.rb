require 'test_helper'
class Finance::Admin::StocksControllerTest < ActionDispatch::IntegrationTest

  setup do
    @finance_admin_stock = create finance_admin_stocks
  end

  test 'index ok' do
    get admin_stocks_url
    assert_response :success
  end

  test 'new ok' do
    get new_admin_stock_url
    assert_response :success
  end

  test 'create ok' do
    assert_difference('Stock.count') do
      post admin_stocks_url, params: { #{singular_table_name}: { #{attributes_string} } }
    end

    assert_response :success
  end

  test 'show ok' do
    get admin_stock_url(@finance_admin_stock)
    assert_response :success
  end

  test 'edit ok' do
    get edit_admin_stock_url(@finance_admin_stock)
    assert_response :success
  end

  test 'update ok' do
    patch admin_stock_url(@finance_admin_stock), params: { #{singular_table_name}: { #{attributes_string} } }
    assert_response :success
  end

  test 'destroy ok' do
    assert_difference('Stock.count', -1) do
      delete admin_stock_url(@finance_admin_stock)
    end

    assert_response :success
  end

end
