# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    name { 'task name' }
    description { 'task description' }
    category { 0 }
  end
end
