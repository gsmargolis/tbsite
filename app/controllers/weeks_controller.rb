class WeeksController < ApplicationController
    before_action :require_user
    
  def index
    @weeks = Weeks.all
  end
  
  def show
    @week = params[:id]
    @games = Game.where(weeknum: @week).order(:id)
   
  end
  
end
