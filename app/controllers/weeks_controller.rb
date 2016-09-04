class WeeksController < ApplicationController
  def index
    @weeks = Weeks.all
  end
  
  def show
    @week = params[:id]
    @games = Game.where(weeknum: @week).order(:id)
   
  end
  
end
