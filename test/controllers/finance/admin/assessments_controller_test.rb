require 'test_helper'
class Finance::Admin::AssessmentsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @finance_admin_assessment = create finance_admin_assessments
  end

  test 'index ok' do
    get admin_assessments_url
    assert_response :success
  end

  test 'new ok' do
    get new_admin_assessment_url
    assert_response :success
  end

  test 'create ok' do
    assert_difference('Assessment.count') do
      post admin_assessments_url, params: { #{singular_table_name}: { #{attributes_string} } }
    end

    assert_response :success
  end

  test 'show ok' do
    get admin_assessment_url(@finance_admin_assessment)
    assert_response :success
  end

  test 'edit ok' do
    get edit_admin_assessment_url(@finance_admin_assessment)
    assert_response :success
  end

  test 'update ok' do
    patch admin_assessment_url(@finance_admin_assessment), params: { #{singular_table_name}: { #{attributes_string} } }
    assert_response :success
  end

  test 'destroy ok' do
    assert_difference('Assessment.count', -1) do
      delete admin_assessment_url(@finance_admin_assessment)
    end

    assert_response :success
  end

end
