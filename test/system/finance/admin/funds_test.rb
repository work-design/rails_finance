require "application_system_test_case"

class FundsTest < ApplicationSystemTestCase
  setup do
    @finance_admin_fund = finance_admin_funds(:one)
  end

  test "visiting the index" do
    visit finance_admin_funds_url
    assert_selector "h1", text: "Funds"
  end

  test "creating a Fund" do
    visit finance_admin_funds_url
    click_on "New Fund"

    fill_in "Amount", with: @finance_admin_fund.amount
    fill_in "Budget", with: @finance_admin_fund.budget
    fill_in "Name", with: @finance_admin_fund.name
    fill_in "Note", with: @finance_admin_fund.note
    click_on "Create Fund"

    assert_text "Fund was successfully created"
    click_on "Back"
  end

  test "updating a Fund" do
    visit finance_admin_funds_url
    click_on "Edit", match: :first

    fill_in "Amount", with: @finance_admin_fund.amount
    fill_in "Budget", with: @finance_admin_fund.budget
    fill_in "Name", with: @finance_admin_fund.name
    fill_in "Note", with: @finance_admin_fund.note
    click_on "Update Fund"

    assert_text "Fund was successfully updated"
    click_on "Back"
  end

  test "destroying a Fund" do
    visit finance_admin_funds_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Fund was successfully destroyed"
  end
end
