# frozen_string_literal: true

require 'rails_helper'

# Tests for the assignments controller
RSpec.describe '/assignments', type: :request do
  fixtures :crew

  before(:each) do
    crew = crew(:test_crew)
    @member = FactoryBot.create(:member, crew: crew, role: 'member')
    @captain = FactoryBot.create(:member, crew: crew,
                                          role: 'captain',
                                          email: 'captain@captain.com')
    Current.crew = crew
  end

  describe 'GET /assignments' do
    context 'member' do
      it 'should render a successful response' do
        Current.member = @member
        sign_in @member

        get assignments_url

        expect(response).to be_successful
      end
    end

    context 'captain' do
      it 'should render a successful response' do
        Current.member = @captain
        sign_in @captain

        get assignments_url

        expect(response).to be_successful
      end
    end
  end

  describe 'GET /assignments/:id' do
    context 'member' do
      it 'should render a successful response' do
        Current.member = @member
        sign_in @member

        task = create(:task)

        assignment = FactoryBot.create(:assignment, task: task,
                                                    member: @member,
                                                    reward_applied: false,
                                                    status: 'in_progress')

        get assignment_url(assignment)

        expect(response).to be_successful
      end
    end

    context 'captain' do
      it 'should render a successful response' do
        Current.member = @captain
        sign_in @captain

        task = create(:task)

        assignment = FactoryBot.create(:assignment, task: task,
                                                    member: @member,
                                                    reward_applied: false,
                                                    status: 'in_progress')

        get assignment_url(assignment)

        expect(response).to be_successful
      end
    end
  end
end
