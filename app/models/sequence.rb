# frozen_string_literal: true

class GoodnessValidator < ActiveModel::Validator
  def validate(record)
    record.errors.add :base, 'seq < 10' if record.values.split(' ').length < 10
  end
end

class Sequence < ApplicationRecord
  validates :values, presence: true,# uniqueness: true,
             format: { with: /\A-?\d+( +-?\d+)*\z/, message: 'only allows numbers' }
  validates_with GoodnessValidator, fields: [:values]
  #validates :output, presence: true
end
