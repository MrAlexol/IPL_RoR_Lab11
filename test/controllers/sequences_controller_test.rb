require "test_helper"

class SequencesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sequence = sequences(:one)
  end

  test "should get index" do
    get sequences_url
    assert_response :success
  end

  test "should get new" do
    get new_sequence_url
    assert_response :success
  end

  test "should create sequence" do
    assert_difference('Sequence.count') do
      post sequences_url, params: { sequence: { output: @sequence.output, values: @sequence.values } }
    end

    assert_redirected_to sequence_url(Sequence.last)
  end

  test "should show sequence" do
    get sequence_url(@sequence)
    assert_response :success
  end

  test "should get edit" do
    get edit_sequence_url(@sequence)
    assert_response :success
  end

  test "should update sequence" do
    patch sequence_url(@sequence), params: { sequence: { output: @sequence.output, values: @sequence.values } }
    assert_redirected_to sequence_url(@sequence)
  end

  test "should destroy sequence" do
    assert_difference('Sequence.count', -1) do
      delete sequence_url(@sequence)
    end

    assert_redirected_to sequences_url
  end
end
