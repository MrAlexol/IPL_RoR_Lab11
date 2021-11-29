# frozen_string_literal: true

require 'test_helper'

# Заменить стандартное содержимое fixtures/sequences.yml на 
  # one: {}
  # two: {}
# при использовании ограничений уникальности в БД

class SequenceTest < ActiveSupport::TestCase
  test "empty sequence mustn't be saved" do
    sequence = Sequence.new
    refute sequence.save
  end

  test "invalid sequence shouldn't be saved" do
    sequence = Sequence.new(output: 'Lorem ipsum')
    refute sequence.valid?, 'sequence is valid without user input'
    assert_not_nil sequence.errors[:values], 'no validation error for field Values'
  end

  test 'valid input should be valid' do
    sequence = Sequence.new(values: '5 6 7 1 0 -1 1 2 3 2 1')
    assert sequence.valid?
  end

  test "duplicate records can't be saved" do
    sequence1 = Sequence.new(values: '5 6 7 1 0 -1 1 2 3 2 1')
    sequence2 = Sequence.new(values: '5 6 7 1 0 -1 1 2 3 2 1')
    assert sequence1.save
    assert_raises ActiveRecord::RecordNotUnique do
      sequence2.save
    end
  end

  test 'record should be saved and read' do
    string = '9 0 2 3 56 -1 1 2 3 2 1'
    sequence = Sequence.new(values: string)
    assert sequence.save
    assert Sequence.find_by(values: string)
  end
end
