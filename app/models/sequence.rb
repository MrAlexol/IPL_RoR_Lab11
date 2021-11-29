# frozen_string_literal: true

# Валидатор введенной последовательности чисел
class GoodnessValidator < ActiveModel::Validator
  def validate(record)
    if record.values.nil?
      record.errors.add :values, 'Параметр не представлен'
      return
    end
    record.errors.add :values, 'Последовательность короче 10 чисел' if record.values.split(' ').length < 10
  end
end

# Модель последовательности
class Sequence < ApplicationRecord
  validates :values, presence: { message: "Вы ничего не ввели" },
             format: { with: /\A-?\d+( +-?\d+)*\z/, message: 'Вводите только цифры через пробел!' }
  validates_with GoodnessValidator, fields: [:values]
  # validates :output, presence: true

  def self.search(search)
    if search
      where(values: search)
    else
      all.last(50)
    end
  end

  def self.search_id(search)
    select(:id).find_by(values: search) if search
  end
end
