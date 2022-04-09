# frozen_string_literal: true

FactoryBot.define do
  factory :member do
    first_name { 'phil' }
    last_name { 'collins' }
    email { 'phil.collins@test.com' }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
