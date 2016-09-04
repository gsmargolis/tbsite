class PagesController < ApplicationController
  def importplayers
    require 'csv'
    @players = []
    CSV.foreach("#{Rails.root}/app/Uploads/Players.csv") do |p|
      player = Player.new(playername: p[1])
      player.save
      @players << [p[1]]
    end
  
  end
  
  def importgames
    require 'csv'
    @games = []
    CSV.foreach("#{Rails.root}/app/Uploads/Games.csv") do |g|
      game = Game.new(weeknum: g[1], awayteam: g[2], hometeam: g[3], line: g[4], awayscore: g[5], homescore: g[6], currentstatus: g[7], ismnf: g[8])
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
  
  
  def home
  end
  
  
end
