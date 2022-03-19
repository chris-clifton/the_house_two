# frozen_string_literal: true

# Assignments controller
# Every action should be authorized via Pundit and should be admin-only
class AssignmentsController < ApplicationController
  before_action :set_assignment, only: %i[show edit update destroy]

  # All Assignment actions should be authorized for admins only
  before_action :check_if_admin

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
    @users      = User.all
    @tasks      = Task.all

    @assignment.build_consequence
    @assignment.build_reward
  end

  # GET /assignments/1/edit
  def edit
    @users = User.all
    @tasks = Task.all
  end

  # POST /assignments or /assignments.json
  def create
    @assignment = Assignment.new(assignment_params)

    respond_to do |format|
      if @assignment.save
        format.html { redirect_to assignment_url(@assignment), notice: 'User task was successfully created.' }
        format.json { render :show, status: :created, location: @assignment }
      else
        @tasks = Task.all
        @users = User.all
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /assignments/1 or /assignments/1.json
  def update
    respond_to do |format|
      if @assignment.update(assignment_params)
        format.html { redirect_to assignment_url(@assignment), notice: 'User task was successfully updated.' }
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
      format.html { redirect_to assignments_url, status: :see_other, notice: 'User task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # PUT /assignments/:id/mark_complete
  def mark_complete
    user       = User.find(params[:user_id])
    assignment = Assignment.find(params[:assignment_id])

    interaction = AssignmentInteractions::MarkComplete.run(user: user,
                                                           assignment: assignment)

    data = { message: interaction.message }

    render json: data
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_assignment
    @assignment = Assignment.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  # Accept nested attribtues for the reward and consequence.
  def assignment_params
    params.require(:assignment).permit(:user_id, :task_id, :due_date, :status,
                                       reward_attributes: [:value,
                                                           :category],
                                       consequence_attributes: [:value,
                                                                :duration,
                                                                :category])
  end

  # TODO: Extract to application controller and document
  def check_if_admin
    current_user.admin?
  end
end
