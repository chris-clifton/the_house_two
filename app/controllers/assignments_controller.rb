# frozen_string_literal: true

# Assignments controller
# Every action should be authorized via Pundit and should be captain-only
class AssignmentsController < ApplicationController
  before_action :set_assignment, only: %i[show edit update destroy]

  # All Assignment actions should be authorized for captains only
  # with the exception of mark_pending_review
  before_action :check_if_captain, except: :mark_pending_review

  # GET /assignments or /assignments.json
  def index
    @assignments = Assignment.all
  end

  # GET /assignments/1 or /assignments/1.json
  def show
  end

  # GET /assignments/new
  def new
    @assignment = Assignment.new
    @members    = Member.all
    @tasks      = Task.all

    @assignment.build_consequence
  end

  # GET /assignments/1/edit
  def edit
    @members = Member.all
    @tasks   = Task.all
  end

  # POST /assignments or /assignments.json
  def create
    @assignment = Assignment.new(assignment_params)

    respond_to do |format|
      if @assignment.save
        format.html { redirect_to assignment_url(@assignment), notice: 'Member task was successfully created.' }
        format.json { render :show, status: :created, location: @assignment }
      else
        @tasks   = Task.all
        @members = Member.all
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /assignments/1 or /assignments/1.json
  def update
    respond_to do |format|
      if @assignment.update(assignment_params)
        format.html { redirect_to assignment_url(@assignment), notice: 'Member task was successfully updated.' }
        format.json { render :show, status: :ok, location: @assignment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /assignments/1 or /assignments/1.json
  # TODO: Soft delete instead
  def destroy
    @assignment.destroy

    respond_to do |format|
      format.html { redirect_to assignments_url, status: :see_other, notice: 'Member task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # PUT /assignments/:id/mark_pending_review
  # Any member should be able to mark their own assignments as pending review
  # TODO: Handle rerendering the Show view with a turbo stream
  # TODO: Handle receiving an optional note
  def mark_pending_review
    assignment = Assignment.find(params[:assignment_id])

    if assignment.mark_pending_review
      data = { message: "This #{assignment.task.category.capitalize} has been marked as 'Pending Review' and is awaiting approval" }
    else
      data = { message: "There was an error updating this #{assignment.task.category.capitalize}" }
    end

    render json: data
  end

  # PUT /assignments/:id/mark_in_progress
  # Any member should be able to mark their own assignments as pending review
  # TODO: Handle rerendering the Show view with a turbo stream
  # TODO: Handle receiving an optional note
  def mark_in_progress
    assignment = Assignment.find(params[:assignment_id])

    if assignment.mark_in_progress
      data = { message: "This #{assignment.task.category.capitalize} has been marked as 'In Progress'" }
    else
      data = { message: "There was an error updating this #{assignment.task.category.capitalize}" }
    end

    render json: data
  end

  # PUT /assignments/:id/mark_complete
  # TODO: Handle receiving an optional note
  def mark_complete
    # TODO: add Pundit authorization here to make sure member is captain
    #       Do I need to pass the member ID as an argument from the Stimulus
    #       controller or are we getting that for free from Devise?
    # TODO: Handle rerendering the Show view with a turbo stream
    assignment = Assignment.find(params[:assignment_id])

    if assignment.mark_complete
      data = { message: "This #{assignment.task.category.capitalize} has been marked as 'Complete'" }
    else
      data = { message: "There was an error updating this #{assignment.task.category.capitalize}" }
    end

    render json: data
  end

  # PUT /assignments/:id/mark_failed
  def mark_failed
    # TODO: add Pundit authorization here to make sure member is captain
    #       Do I need to pass the member ID as an argument from the Stimulus
    #       controller or are we getting that for free from Devise?
    # TODO: Handle rerendering the Show view with a turbo stream
    # TODO: Handle receiving an optional note
    assignment = Assignment.find(params[:assignment_id])

    if assignment.mark_failed
      data = { message: "This #{assignment.task.category.capitalize} has been marked as 'Failed'" }
    else
      data = { message: "There was an error updating this #{assignment.task.category.capitalize}" }
    end

    render json: data
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_assignment
    @assignment = Assignment.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  # Accept nested attribtues for the consequence.
  # Do not permit the 'status' attribute as we want to handle that separately
  # so we can make use of our AASM logic.
  def assignment_params
    params.require(:assignment).permit(:member_id, :task_id, :due_date, :reward,
                                       consequence_attributes: [:value,
                                                                :duration,
                                                                :category])
  end

  # TODO: Extract to application controller and document
  def check_if_captain
    current_member.captain?
  end
end
