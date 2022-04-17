# frozen_string_literal: true

class MembersController < ApplicationController
  def index
    @members = Member.all
  end
  
  def show
    @member = Member.friendly.find(params[:slug])
  end
end
