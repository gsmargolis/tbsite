class PagesController < ApplicationController
  def importplayers
    require 'csv'
    CSV.foreach("#{Rails.root}/app/Uploads/Players.csv") do |p|
    player = Player.new(playername: p[1])
    player.save
    
    end
  
  end
  
  def importgames
    require 'csv'
    CSV.foreach("#{Rails.root}/app/Uploads/Games.csv") do |p|
    game = Game.new(playername: p[1])
    player.save
    
    end
  
  end
  
  
  def home
  end
  
  
end
