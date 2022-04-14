# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Assignment, type: :model do
  fixtures :crew

  before(:each) do
    @crew = crew(:test_crew)
    @member = FactoryBot.create(:member, crew: @crew, role: 'member')
    @captain = FactoryBot.create(:member, crew: @crew,
                                          role: 'captain',
                                          email: 'captain@captain.com')
    Current.crew = crew
  end

  describe 'associations' do
    it { should belong_to(:member) }
    it { should belong_to(:task) }
    it { should accept_nested_attributes_for(:consequence) }
  end

  describe 'validations' do
    it { should validate_presence_of(:member_id) }
    it { should validate_presence_of(:task_id) }
    it { should validate_presence_of(:crew_id) }
    it { should validate_presence_of(:status) }
  end

  describe 'schema' do
    it { should have_db_index(:crew_id) }
    it { should have_db_index(:member_id) }
    it { should have_db_index(:task_id) }
  end

  describe 'status' do
    context 'is in_progress' do
      context 'and member' do
        it 'should be able to change status to pending_review' do
          Current.member = @member
          task           = create(:task)

          assignment = FactoryBot.create(:assignment, task: task,
                                                      member: @member,
                                                      reward_applied: false,
                                                      status: 'in_progress')

          # Test the following:
          # - initial state is 'in_progress'
          # - when we run the :mark_pending_review event, we call the :update_pending_review callback
          # - the state machine's transition is successful
          # - the resulting state is 'pending_review'
          expect(assignment).to have_state(:in_progress).on(:status)
          expect(assignment).to receive(:update_pending_review)
          expect(assignment).to transition_from(:in_progress).to(:pending_review).on_event(:mark_pending_review).on(:status)
          expect(assignment).to have_state(:pending_review).on(:status)
        end

        it 'should not be able to change status to complete' do
          Current.member = @member
          task           = create(:task)

          assignment = FactoryBot.create(:assignment, task: task,
                                                      member: @member,
                                                      reward_applied: false,
                                                      status: 'in_progress')

          # Test the following:
          # - initial state is 'in_progress'
          # - since a member should not be able to mark this assignment as complete,
          #   we should never run the :update_complete callback
          # - the state machine's transition is not successful
          # - the state never changes and remains as 'in_progress'
          expect(assignment).to have_state(:in_progress).on(:status)
          expect(assignment).not_to receive(:update_complete)
          expect(assignment).not_to transition_from(:in_progress).to(:complete).on_event(:mark_complete).on(:status)
          expect(assignment).to have_state(:in_progress).on(:status)
        end

        it 'should not be able to change status to failed' do
          Current.member = @member
          task           = create(:task)

          assignment = FactoryBot.create(:assignment, task: task,
                                                      member: @member,
                                                      reward_applied: false,
                                                      status: 'in_progress')

          # Test the following:
          # - initial state is 'in_progress'
          # - since a member should not be able to mark this assignment as failed,
          #   we should never run the :update_failed callback
          # - the state machine's transition is not successful
          # - the state never changes and remains as 'in_progress'
          expect(assignment).to have_state(:in_progress).on(:status)
          expect(assignment).not_to receive(:update_failed)
          expect(assignment).not_to transition_from(:in_progress).to(:failed).on_event(:mark_failed).on(:status)
          expect(assignment).to have_state(:in_progress).on(:status)
        end

        it 'should not be able to change status if it doesnt belong to them' do
          Current.member    = @member
          task              = create(:task)
          some_other_member = FactoryBot.create(:member, first_name: 'some other',
                                                         last_name: 'member',
                                                         crew: @crew,
                                                         email: 'someothermember@example.com',
                                                         role: 'member')

          assignment = FactoryBot.create(:assignment, task: task,
                                                      member: some_other_member,
                                                      reward_applied: false,
                                                      status: 'in_progress')

          # Test the following:
          # - initial state is 'in_progress'
          # - since this assignment doesnt belong to @member, they should not
          #   be able to update it and we should never run the
          #   :update_pending_review callback
          # - the state machine's transition is not successful
          # - the status never changes and remains as 'in_progress'
          expect(assignment).to have_state(:in_progress).on(:status)
          expect(assignment).not_to receive(:update_in_progress)
          expect(assignment).not_to transition_from(:in_progress).to(:pending_review).on_event(:mark_pending_review).on(:status)
          expect(assignment).to have_state(:in_progress).on(:status)
        end

        it 'should not be able to change status if its already marked complete' do
          Current.member    = @member
          task              = create(:task)

          assignment = FactoryBot.create(:assignment, task: task,
                                                      member: @member,
                                                      reward_applied: false,
                                                      status: 'complete')

          # Test the following:
          # - initial state is :complete
          # - since this assignment is already marked :complete, a member should
          #   not have the authorization to move it back to :pending_review
          # - the :update_complete callback should not be called
          # - the state machine' transition is not successful
          # - the status never changes and remains :complete
          expect(assignment).to have_state(:complete).on(:status)
          expect(assignment).not_to receive(:update_complete)
          expect(assignment).not_to transition_from(:complete).to(:pending_review).on_event(:mark_pending_review).on(:status)
          expect(assignment).to have_state(:complete).on(:status)
        end

        it 'should not be able to change status if its already marked failed' do
          Current.member    = @member
          task              = create(:task)

          assignment = FactoryBot.create(:assignment, task: task,
                                                      member: @member,
                                                      reward_applied: false,
                                                      status: 'failed')

          # Test the following:
          # - initial state is :failed
          # - since this assignment is already marked :failed, a member should
          #   not have the authorization to move it back to :pending_review
          # - the :update_failed callback should not be called
          # - the state machine' transition is not successful
          # - the status never changes and remains :failed
          expect(assignment).to have_state(:failed).on(:status)
          expect(assignment).not_to receive(:update_failed)
          expect(assignment).not_to transition_from(:failed).to(:pending_review).on_event(:mark_pending_review).on(:status)
          expect(assignment).to have_state(:failed).on(:status)
        end
      end

      context 'and captain' do
        it 'should be able to change status to pending_review' do
          Current.member = @captain
          task           = create(:task)

          assignment = FactoryBot.create(:assignment, task: task,
                                                      member: @member,
                                                      reward_applied: false,
                                                      status: 'in_progress')

          # Test the following:
          # - initial state is 'in_progress'
          # - when we run the :mark_pending_review event, we call the :update_pending_review callback
          # - the state machine's transition is successful
          # - the resulting status is 'pending_review'
          expect(assignment).to have_state(:in_progress).on(:status)
          expect(assignment).to receive(:update_pending_review)
          expect(assignment).to transition_from(:in_progress).to(:pending_review).on_event(:mark_pending_review).on(:status)
          expect(assignment).to have_state(:pending_review).on(:status)
        end

        it 'should be able to change status to complete' do
          Current.member = @captain
          task           = create(:task)

          assignment = FactoryBot.create(:assignment, task: task,
                                                      member: @member,
                                                      reward_applied: false,
                                                      status: 'in_progress')

          # Test the following:
          # - initial state is 'in_progress'
          # - when we run the :mark_complete event, we call the :update_complete callback
          # - the state machine's transition is successful
          # - the resulting status is 'complete'
          expect(assignment).to have_state(:in_progress).on(:status)
          expect(assignment).to receive(:update_complete)
          expect(assignment).to transition_from(:in_progress).to(:complete).on_event(:mark_complete).on(:status)
          expect(assignment).to have_state(:complete).on(:status)
        end

        it 'should be able to change status to failed' do
          Current.member = @captain
          task           = create(:task)

          assignment = FactoryBot.create(:assignment, task: task,
                                                      member: @member,
                                                      reward_applied: false,
                                                      status: 'in_progress')

          # Test the following:
          # - initial state is 'in_progress'
          # - when we run the :mark_failed event, we call the :update_failed callback
          # - the state machine's transition is successful
          # - the resulting status is 'failed'
          expect(assignment).to have_state(:in_progress).on(:status)
          expect(assignment).to receive(:update_failed)
          expect(assignment).to transition_from(:in_progress).to(:failed).on_event(:mark_failed).on(:status)
          expect(assignment).to have_state(:failed).on(:status)
        end
      end
    end

    context 'is pending_review' do
      context 'and member' do
        it 'should be able to change status to in_progress' do
          Current.member = @member
          task           = create(:task)

          assignment = FactoryBot.create(:assignment, task: task,
                                                      member: @member,
                                                      reward_applied: false,
                                                      status: 'pending_review')
          # Test the following:
          # - initial state is 'pending_review'
          # - when we run the :mark_in_progress event, we call the :update_in_progress callback
          # - the state machine's transition is successful
          # - the resulting status is 'in_progress'
          expect(assignment).to have_state(:pending_review).on(:status)
          expect(assignment).to receive(:update_in_progress)
          expect(assignment).to transition_from(:pending_review).to(:in_progress).on_event(:mark_in_progress).on(:status)
          expect(assignment).to have_state(:in_progress).on(:status)
        end

        it 'should not be able to change status to complete' do
          Current.member = @member
          task           = create(:task)

          assignment = FactoryBot.create(:assignment, task: task,
                                                      member: @member,
                                                      reward_applied: false,
                                                      status: 'pending_review')

          # Test the following:
          # - initial state is 'pending_review'
          # - since a member should not be able to mark this assignment as complete,
          #   we should never run the :update_complete callback
          # - the state machine's transition is not successful
          # - the status never changes and remains as 'pending_review'
          expect(assignment).to have_state(:pending_review).on(:status)
          expect(assignment).not_to receive(:update_complete)
          expect(assignment).not_to transition_from(:pending_review).to(:in_progress).on_event(:mark_complete).on(:status)
          expect(assignment).to have_state(:pending_review).on(:status)
        end

        it 'should not be able to change status to failed' do
          Current.member = @member
          task           = create(:task)

          assignment = FactoryBot.create(:assignment, task: task,
                                                      member: @member,
                                                      reward_applied: false,
                                                      status: 'pending_review')

          # Test the following:
          # - initial state is 'pending_review'
          # - since a member should not be able to mark this assignment as failed,
          #   we should never run the :update_failed callback
          # - the state machine's transition is not successful
          # - the status never changes and remains as 'pending_review'
          expect(assignment).to have_state(:pending_review).on(:status)
          expect(assignment).not_to receive(:update_failed)
          expect(assignment).not_to transition_from(:pending_review).to(:in_progress).on_event(:mark_failed).on(:status)
          expect(assignment).to have_state(:pending_review).on(:status)
        end

        it 'should not be able to change status if it doesnt belong to them' do
          Current.member    = @member
          task              = create(:task)
          some_other_member = FactoryBot.create(:member, first_name: 'some other',
                                                         last_name: 'member',
                                                         crew: @crew,
                                                         email: 'someothermember@example.com',
                                                         role: 'member')

          assignment = FactoryBot.create(:assignment, task: task,
                                                      member: some_other_member,
                                                      reward_applied: false,
                                                      status: 'pending_review')

          # Test the following:
          # - initial state is 'pending_review'
          # - since this assignment doesnt belong to @member, they should not
          #   be able to update it and we should never run the
          #   :update_pending_review callback
          # - the state machine's transition is not successful
          # - the status never changes and remains as 'pending_review'
          expect(assignment).to have_state(:pending_review).on(:status)
          expect(assignment).not_to receive(:update_pending_review)
          expect(assignment).not_to transition_from(:pending_review).to(:pending_review).on_event(:mark_pending_review).on(:status)
          expect(assignment).to have_state(:pending_review).on(:status)
        end
      end

      context 'and captain' do
        it 'should be able to change status to in_progress' do
          Current.member = @captain
          task           = create(:task)

          assignment = FactoryBot.create(:assignment, task: task,
                                                      member: @member,
                                                      reward_applied: false,
                                                      status: 'pending_review')

          # Test the following:
          # - initial state is 'pending_review'
          # - when we run the :mark_in_progress event, we call the :update_in_progress callback
          # - the state machine's transition is successful
          # - the resulting status is 'in_progress'
          expect(assignment).to have_state(:pending_review).on(:status)
          expect(assignment).to receive(:update_in_progress)
          expect(assignment).to transition_from(:pending_review).to(:in_progress).on_event(:mark_in_progress).on(:status)
          expect(assignment).to have_state(:in_progress).on(:status)
        end

        it 'should be able to change status to complete' do
          Current.member = @captain
          task           = create(:task)

          assignment = FactoryBot.create(:assignment, task: task,
                                                      member: @member,
                                                      reward_applied: false,
                                                      status: 'pending_review')

          # Test the following:
          # - initial state is 'pending_review'
          # - when we run the :mark_complete event, we call the :update_complete callback
          # - the state machine's transition is successful
          # - the resulting status is 'complete'
          expect(assignment).to have_state(:pending_review).on(:status)
          expect(assignment).to receive(:update_complete)
          expect(assignment).to transition_from(:pending_review).to(:complete).on_event(:mark_complete).on(:status)
          expect(assignment).to have_state(:complete).on(:status)
        end

        it 'should be able to change status to failed' do
          Current.member = @captain
          task           = create(:task)

          assignment = FactoryBot.create(:assignment, task: task,
                                                      member: @member,
                                                      reward_applied: false,
                                                      status: 'pending_review')

          # Test the following:
          # - initial state is 'pending review'
          # - when we run the :mark_failed event, we call the :update_failed callback
          # - the state machine's transition is successful
          # - the resulting status is 'failed'
          expect(assignment).to have_state(:pending_review).on(:status)
          expect(assignment).to receive(:update_failed)
          expect(assignment).to transition_from(:pending_review).to(:failed).on_event(:mark_failed).on(:status)
          expect(assignment).to have_state(:failed).on(:status)
        end
      end
    end
  
    context 'is complete' do
      context 'and member' do
        it 'should not be able to change status to in_progress' do
          Current.member = @member
          task           = create(:task)

          assignment = FactoryBot.create(:assignment, task: task,
                                                      member: @member,
                                                      reward_applied: false,
                                                      status: 'complete')

          # Test the following:
          # - initial state is 'complete'
          # - since a member should not be able to mark this assignment as complete,
          #   we should never run the :update_in_progress callback
          # - the state machine's transition is not successful
          # - the status never changes and remains as 'complete'
          expect(assignment).to have_state(:complete).on(:status)
          expect(assignment).not_to receive(:update_in_progress)
          expect(assignment).not_to transition_from(:complete).to(:in_progress).on_event(:mark_in_progress).on(:status)
          expect(assignment).to have_state(:complete).on(:status)
        end

        it 'should not be able to change status to pending_review' do
          Current.member = @member
          task           = create(:task)

          assignment = FactoryBot.create(:assignment, task: task,
                                                      member: @member,
                                                      reward_applied: false,
                                                      status: 'complete')

          # Test the following:
          # - initial state is 'complete'
          # - since a member should not be able to mark this assignment as pending_review,
          #   we should never run the :update_pending_review callback
          # - the state machine's transition is not successful
          # - the status never changes and remains as 'complete'
          expect(assignment).to have_state(:complete).on(:status)
          expect(assignment).not_to receive(:update_pending_review)
          expect(assignment).not_to transition_from(:complete).to(:pending_review).on_event(:mark_pending_review).on(:status)
          expect(assignment).to have_state(:complete).on(:status)
        end

        it 'should not be able to change status to failed' do
          Current.member = @member
          task           = create(:task)

          assignment = FactoryBot.create(:assignment, task: task,
                                                      member: @member,
                                                      reward_applied: false,
                                                      status: 'complete')

          # Test the following:
          # - initial state is 'complete'
          # - since a member should not be able to mark this assignment as failed,
          #   we should never run the :update_failed callback
          # - the state machine's transition is not successful
          # - the status never changes and remains as 'complete'
          expect(assignment).to have_state(:complete).on(:status)
          expect(assignment).not_to receive(:update_failed)
          expect(assignment).not_to transition_from(:complete).to(:failed).on_event(:mark_failed).on(:status)
          expect(assignment).to have_state(:complete).on(:status)
        end

        it 'should not be able to change status if it doesnt belong to them' do
          Current.member    = @member
          task              = create(:task)
          some_other_member = FactoryBot.create(:member, first_name: 'some other',
                                                         last_name: 'member',
                                                         crew: @crew,
                                                         email: 'someothermember@example.com',
                                                         role: 'member')

          assignment = FactoryBot.create(:assignment, task: task,
                                                      member: some_other_member,
                                                      reward_applied: false,
                                                      status: 'complete')

          # Test the following:
          # - initial state is 'complete'
          # - since this assignment doesnt belong to @member, they should not
          #   be able to update it and we should never run the
          #   :update_pending_review callback
          # - the state machine's transition is not successful
          # - the status never changes and remains as 'complete'
          expect(assignment).to have_state(:complete).on(:status)
          expect(assignment).not_to receive(:update_pending_review)
          expect(assignment).not_to transition_from(:complete).to(:pending_review).on_event(:mark_pending_review).on(:status)
          expect(assignment).to have_state(:complete).on(:status)
        end
      end

      context 'and captain' do
        it 'should be able to change status to in_progress' do
          Current.member = @captain
          task           = create(:task)

          assignment = FactoryBot.create(:assignment, task: task,
                                                      member: @member,
                                                      reward_applied: false,
                                                      status: 'complete')

          # Test the following:
          # - initial state is 'complete'
          # - when we run the :mark_in_progress event, we call the :update_in_progress callback
          # - the state machine's transition is successful
          # - the resulting status is 'in_progress'
          expect(assignment).to have_state(:complete).on(:status)
          expect(assignment).to receive(:update_in_progress)
          expect(assignment).to transition_from(:complete).to(:in_progress).on_event(:mark_in_progress).on(:status)
          expect(assignment).to have_state(:in_progress).on(:status)
        end

        it 'should be able to change status to failed' do
          Current.member = @captain
          task           = create(:task)

          assignment = FactoryBot.create(:assignment, task: task,
                                                      member: @member,
                                                      reward_applied: false,
                                                      status: 'complete')

          # Test the following:
          # - initial state is 'complete'
          # - when we run the :mark_failed event, we call the :update_failed callback
          # - the state machine's transition is successful
          # - the resulting status is 'failed'
          expect(assignment).to have_state(:complete).on(:status)
          expect(assignment).to receive(:update_failed)
          expect(assignment).to transition_from(:complete).to(:failed).on_event(:mark_failed).on(:status)
          expect(assignment).to have_state(:failed).on(:status)
        end

        it 'should be able to change status to pending_review' do
          Current.member = @captain
          task           = create(:task)

          assignment = FactoryBot.create(:assignment, task: task,
                                                      member: @member,
                                                      reward_applied: false,
                                                      status: 'complete')

          # Test the following:
          # - initial state is 'complete'
          # - when we run the :mark_pending_review event, we call the :update_pending_review callback
          # - the state machine's transition is successful
          # - the resulting status is 'pending_review'
          expect(assignment).to have_state(:complete).on(:status)
          expect(assignment).to receive(:update_pending_review)
          expect(assignment).to transition_from(:complete).to(:pending_review).on_event(:mark_pending_review).on(:status)
          expect(assignment).to have_state(:pending_review).on(:status)
        end
      end
    end

    context 'is failed' do
      context 'and member' do
        it 'should not be able to change status to in_progress' do
          Current.member = @member
          task           = create(:task)

          assignment = FactoryBot.create(:assignment, task: task,
                                                      member: @member,
                                                      reward_applied: false,
                                                      status: 'failed')

          # Test the following:
          # - initial state is 'failed'
          # - since a member should not be able to mark this assignment as failed,
          #   we should never run the :update_failed callback
          # - the state machine's transition is not successful
          # - the status never changes and remains as 'failed'
          expect(assignment).to have_state(:failed).on(:status)
          expect(assignment).not_to receive(:update_failed)
          expect(assignment).not_to transition_from(:failed).to(:failed).on_event(:mark_failed).on(:status)
          expect(assignment).to have_state(:failed).on(:status)
        end

        it 'should not be able to change status to pending_review' do
          Current.member = @member
          task           = create(:task)

          assignment = FactoryBot.create(:assignment, task: task,
                                                      member: @member,
                                                      reward_applied: false,
                                                      status: 'failed')

          # Test the following:
          # - initial state is 'failed'
          # - since a member should not be able to mark this assignment as pending_review,
          #   we should never run the :update_pending_review callback
          # - the state machine's transition is not successful
          # - the status never changes and remains as 'failed'
          expect(assignment).to have_state(:failed).on(:status)
          expect(assignment).not_to receive(:update_pending_review)
          expect(assignment).not_to transition_from(:failed).to(:pending_review).on_event(:mark_pending_review).on(:status)
          expect(assignment).to have_state(:failed).on(:status)
        end

        it 'should not be able to change status to complete' do
          Current.member = @member
          task           = create(:task)

          assignment = FactoryBot.create(:assignment, task: task,
                                                      member: @member,
                                                      reward_applied: false,
                                                      status: 'failed')

          # Test the following:
          # - initial state is 'failed'
          # - since a member should not be able to mark this assignment as failed,
          #   we should never run the :update_complete callback
          # - the state machine's transition is not successful
          # - the status never changes and remains as 'failed'
          expect(assignment).to have_state(:failed).on(:status)
          expect(assignment).not_to receive(:update_complete)
          expect(assignment).not_to transition_from(:failed).to(:failed).on_event(:mark_complete).on(:status)
          expect(assignment).to have_state(:failed).on(:status)
        end
      end

      context 'and captain' do
        it 'should be able to change status to in_progress' do
          Current.member = @captain
          task           = create(:task)

          assignment = FactoryBot.create(:assignment, task: task,
                                                      member: @member,
                                                      reward_applied: false,
                                                      status: 'failed')

          # Test the following:
          # - initial state is 'failed'
          # - when we run the :mark_in_progress event, we call the :update_in_progress callback
          # - the state machine's transition is successful
          # - the resulting status is 'in_progress'
          expect(assignment).to have_state(:failed).on(:status)
          expect(assignment).to receive(:update_in_progress)
          expect(assignment).to transition_from(:failed).to(:in_progress).on_event(:mark_in_progress).on(:status)
          expect(assignment).to have_state(:in_progress).on(:status)
        end

        it 'should be able to change status to pending_review' do
          Current.member = @captain
          task           = create(:task)

          assignment = FactoryBot.create(:assignment, task: task,
                                                      member: @member,
                                                      reward_applied: false,
                                                      status: 'failed')

          # Test the following:
          # - initial state is 'failed'
          # - when we run the :mark_pending_review event, we call the :update_pending_review callback
          # - the state machine's transition is successful
          # - the resulting status is 'pending_review'
          expect(assignment).to have_state(:failed).on(:status)
          expect(assignment).to receive(:update_pending_review)
          expect(assignment).to transition_from(:failed).to(:pending_review).on_event(:mark_pending_review).on(:status)
          expect(assignment).to have_state(:pending_review).on(:status)
        end

        it 'should be able to change status to complete' do
          Current.member = @captain
          task           = create(:task)

          assignment = FactoryBot.create(:assignment, task: task,
                                                      member: @member,
                                                      reward_applied: false,
                                                      status: 'failed')

          # Test the following:
          # - initial state is 'failed'
          # - when we run the :mark_complete event, we call the :update_complete callback
          # - the state machine's transition is successful
          # - the resulting status is 'complete'
          expect(assignment).to have_state(:failed).on(:status)
          expect(assignment).to receive(:update_complete)
          expect(assignment).to transition_from(:failed).to(:complete).on_event(:mark_complete).on(:status)
          expect(assignment).to have_state(:complete).on(:status)
        end
      end
    end
  end
end
