# frozen_string_literal: true

# Chores Controller
class ChoresController < ApplicationController
  before_action :set_chore, only: %i[show edit update destroy]
  before_action :check_if_admin, only: %i[new edit create update destroy]

  # GET /chores or /chores.json
  def index
    @chores = Chore.all
  end

  # GET /chores/1 or /chores/1.json
  def show
  end

  # GET /chores/new
  def new
    @chore = Chore.new
  end

  # GET /chores/1/edit
  def edit
  end

  # POST /chores or /chores.json
  def create
    @chore = Chore.new(chore_params)

    respond_to do |format|
      if @chore.save
        format.html { redirect_to chore_url(@chore), notice: "Chore was successfully created." }
        format.json { render :show, status: :created, location: @chore }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @chore.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /chores/1 or /chores/1.json
  def update
    respond_to do |format|
      if @chore.update(chore_params)
        format.html { redirect_to chore_url(@chore), notice: "Chore was successfully updated." }
        format.json { render :show, status: :ok, location: @chore }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @chore.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chores/1 or /chores/1.json
  # TODO: Lets make these soft deletes, especially if we want to be able to
  #       view histories and whatnot. Use discard gem.
  def destroy
    @chore.destroy

    respond_to do |format|
      format.html { redirect_to chores_path, status: :see_other, notice: "Chore was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_chore
    @chore = Chore.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def chore_params
    params.require(:chore).permit(:name, :description)
  end

  # TODO: Extract to application controller and document
  def check_if_admin
    current_user.admin?
  end
end
