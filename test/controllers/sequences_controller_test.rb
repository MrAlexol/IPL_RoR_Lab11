require "test_helper"

class SequencesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sequence = sequences(:one)
    @controller = SequencesController.new
  end

  test "should get index" do
    get sequences_url
    assert_response :success
  end

  test "should get new" do
    get new_sequence_url
    assert_response :success
  end

  test "should show sequence" do
    get sequence_url(@sequence)
    assert_response :success
  end

  test "should destroy sequence" do
    assert_difference('Sequence.count', -1) do
      delete sequence_url(@sequence)
    end

    assert_redirected_to sequences_url
  end

  test 'should calculate different answers for different queries' do
    result1 = @controller.send :make_output, '1 2 3 1 2 3 -7 5 4 3 2'
    result2 = @controller.send :make_output, '1 3 -7 -8 -9 0 4 5 4 3 2'
    assert_not_equal result1, result2
  end
end
