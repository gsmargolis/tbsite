class WeeksController < ApplicationController
  def index
    @weeks = Weeks.all
  end
  
  def show
    #@week = Weeks.find(params[:id]])
    @week = params[:id]
  end
  
end
