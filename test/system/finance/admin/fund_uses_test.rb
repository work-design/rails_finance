require "application_system_test_case"

class FundUsesTest < ApplicationSystemTestCase
  setup do
    @finance_admin_fund_use = finance_admin_fund_uses(:one)
  end

  test "visiting the index" do
    visit finance_admin_fund_uses_url
    assert_selector "h1", text: "Fund Uses"
  end

  test "creating a Fund use" do
    visit finance_admin_fund_uses_url
    click_on "New Fund Use"

    fill_in "Amount", with: @finance_admin_fund_use.amount
    fill_in "Budget amount", with: @finance_admin_fund_use.budget_amount
    fill_in "Financial", with: @finance_admin_fund_use.financial_id
    fill_in "Financial type", with: @finance_admin_fund_use.financial_type
    fill_in "Note", with: @finance_admin_fund_use.note
    click_on "Create Fund use"

    assert_text "Fund use was successfully created"
    click_on "Back"
  end

  test "updating a Fund use" do
    visit finance_admin_fund_uses_url
    click_on "Edit", match: :first

    fill_in "Amount", with: @finance_admin_fund_use.amount
    fill_in "Budget amount", with: @finance_admin_fund_use.budget_amount
    fill_in "Financial", with: @finance_admin_fund_use.financial_id
    fill_in "Financial type", with: @finance_admin_fund_use.financial_type
    fill_in "Note", with: @finance_admin_fund_use.note
    click_on "Update Fund use"

    assert_text "Fund use was successfully updated"
    click_on "Back"
  end

  test "destroying a Fund use" do
    visit finance_admin_fund_uses_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Fund use was successfully destroyed"
  end
end
