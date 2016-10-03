class PagesController < ApplicationController
    before_action :require_user, except: [:home]
    before_action :require_admin, only: [:showlogs]
    
  def showlogs
    
  end
  
  def importplayers
    require 'csv'
    @players = []
    Player.destroy_all
    CSV.foreach("#{Rails.root}/app/Uploads/Players 2016.csv") do |p|
      player = Player.new(playername: p[1], division: p[0])
      player.save
      @players << [p[1]]
    end
  
  end
  
  def importgames
    require 'csv'
    @games = []
    CSV.foreach("#{Rails.root}/app/Uploads/Games.csv") do |g|
      game = Game.new(weeknum: g[1], awayteam: g[3], hometeam: g[4], line: g[5], awayscore: g[6], homescore: g[7], currentstatus: g[8], ismnf: g[9])
      game.save
      @games << game
    end
  
  end
  
  def importpicks
    require 'csv'
    @picks = []
    CSV.foreach("#{Rails.root}/app/Uploads/Picks.csv") do |p|
      pick = Pick.new(player_id: p[1], weeknum: p[2], game_id: p[3], picktype: p[4], gamepick: p[5])
      pick.save
      @picks << pick
    end
  end
  
    
  def importawards
    require 'csv'
    @awards = []
    CSV.foreach("#{Rails.root}/app/Uploads/Awards.csv") do |a|
      award = Award.new(awardtype: a[1], weeknum: a[2], player_id: a[3])
      award.save
      @awards << award
    end
  end
  
  
  def updateawards
    @week = params[:id]
  end
  
  
  def players
    @players = Player.all
  end
  
  def summary

  end
  
  def home
    redirect_to '/summary'
  end
  
  
end
