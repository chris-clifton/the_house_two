# frozen_string_literal: true

# AssignedChores controller
# Every action should be authorized via Pundit and should be admin-only
class AssignedChoresController < ApplicationController
  before_action :set_assigned_chore, only: %i[show edit update destroy]

  # All AssignedChore actions should be authorized for admins only
  before_action :check_if_admin

  # GET /assigned_chores or /assigned_chores.json
  def index
    @assigned_chores = AssignedChore.all
  end

  # GET /assigned_chores/1 or /assigned_chores/1.json
  def show
  end

  # GET /assigned_chores/new
  def new
    @assigned_chore = AssignedChore.new
    @users      = User.all
    @chores     = Chore.all
    @assigned_chore.build_consequence
    @assigned_chore.build_reward
  end

  # GET /assigned_chores/1/edit
  def edit
    @users  = User.all
    @chores = Chore.all
  end

  # POST /assigned_chores or /assigned_chores.json
  def create
    @assigned_chore = AssignedChore.new(assigned_chore_params)

    respond_to do |format|
      if @assigned_chore.save
        format.html { redirect_to assigned_chore_url(@assigned_chore), notice: 'User chore was successfully created.' }
        format.json { render :show, status: :created, location: @assigned_chore }
      else
        @chores = Chore.all
        @users  = User.all
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @assigned_chore.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /assigned_chores/1 or /assigned_chores/1.json
  def update
    respond_to do |format|
      if @assigned_chore.update(assigned_chore_params)
        format.html { redirect_to assigned_chore_url(@assigned_chore), notice: 'User chore was successfully updated.' }
        format.json { render :show, status: :ok, location: @assigned_chore }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @assigned_chore.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /assigned_chores/1 or /assigned_chores/1.json
  # TODO: Soft delete instead
  def destroy
    @assigned_chore.destroy

    respond_to do |format|
      format.html { redirect_to assigned_chores_url, notice: 'User chore was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_assigned_chore
    @assigned_chore = AssignedChore.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def assigned_chore_params
    params.require(:assigned_chore).permit(:user_id, :chore_id)
  end

  # TODO: Extract to application controller and document
  def check_if_admin
    current_user.admin?
  end
end
