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
  # validates :output, presence: true

  def self.search(search)
    if search
      where(values: search)
    else
      all.last(10)
    end
  end

  def self.search_id(search)
    select(:id).find_by(values: search) if search
  end
end
