# frozen_string_literal: true

class MembersController < ApplicationController
  def show
    @member = Member.friendly.find(params[:slug])
  end

  def index
  end
end
