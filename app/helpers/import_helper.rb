module ImportHelper
  
  def getdata
   
   require 'json'
   
    page = HTTParty.get('http://www.cbssports.com/login?xurl=http://wilburnstb.football.cbssports.com/office-pool/standings/live?u=1&userid=c51999&password=stingray')
    datastart = page.index("var opmLS = new CBSi.app.OPMLiveStandings(")
    datastart = page.index('{"alert"', datastart)
    dataend = page.index('} );', datastart)
    
    firstblock = page[datastart..dataend]
    
    datastart = page.index('{', dataend + 1)
    dataend = page.index('}', datastart)
    
    secondblock = page[datastart..dataend]
    
    firstjson = JSON.parse(firstblock)
    secondjson = JSON.parse(secondblock)

    mnfgame = firstjson["mnfGameId"][4,firstjson["mnfGameId"].size - 3]
    week = firstjson["week"] 

    #/(.*?)\n/.match(secondjson["/ffball/games"])[1] - first game status
    rawgamedata = []
    gamedata = []
    games = []
    spreads = {}
    picks = []
    players = []
    
    firstjson["spreads"].each do
      
    end
    
    rawgamedata = secondjson["/ffball/games"].scan(/(.*?)\n/)
    rawgamedata.each do |gd|
      gamedata << { gd[0].split(/\|/)[0][13,gd[0].split(/\|/)[0].size - 13] => gd[0].split(/\|/)}
      #gamedata.last[0] = gamedata.last[0][13,gamedata.last[0].size - 13]
    end
    
    

    rawgames = firstjson["games"]["nfl"]
    #Game.where(weeknum: week).destroy_all
    rawgames.each do |g|
     # Game.create(gamename: g[4,g.size - 3], awayteam: g[4,g.size - 3].split(/@/)[0], hometeam: g[4,g.size - 3].split(/@/)[1], awayscore: (gamedata.find{|h| h.first[0] == g[4,g.size - 3]}.first[1][10]), homescore: (gamedata.find {|h| h.first[0] == g[4,g.size - 3]}.first[1][11]), line: firstjson["spreads"][g], ismnf: (mnfgame == g[4,g.size - 3]), weeknum: week)
    end
    games = Game.where(weeknum: week)
    players = Player.all
    
    
    totalgames = games.size
    rawpicks = firstjson["teams"]
    Pick.where(weeknum: week).destroy_all
    rawpicks.each do |p|
      pickcount = []
      playerid = players.find_by(playername: p["name"])
      if p.key?("picks") #Picks exist and are visible
        p["picks"].each do |x|
          if x[0] == "mnf"
            picktype = "Points"
            gamepick = x["mnf"]
            pickgame = games.find_by(gamename: x[0][4,x.size - 3])
            picks << {:weeknum => week, :player => players.find_by(playername: p["name"]), :game => games.find_by(gamename: x[0][4,x.size - 3]), :picktype => picktype, :gamepick => gamepick }
          elsif x[0] = "time"
          else
            picktype = "Team"
            pickgame = x[0][4,x.size - 3]
            gamepick = x[1]["winner"]
            pickcount << pickgame
            picks << {:weeknum => week, :player => players.find_by(playername: p["name"]), :game => games.find_by(gamename: x[0][4,x.size - 3]), :picktype => picktype , :gamepick => gamepick}  
          end
        end
      elsif p.key?("numGames") #Picks exist but are not visible
        for i in 0..(totalgames - 1)
          picktype = "Team"
          pickgame = games[i]
          gamepick = "X"
          picks << {:weeknum => week, :player => players.find_by(playername: p["name"]), :game => games[i], :picktype => picktype, :gamepick => gamepick}
        end
      else  #Picks don't exist
  
    end 
      if (pickcount.size > 0) && (pickcount.size < totalgames)
        games.each do |g|
          if !(pickcount.include? games[:gamename])
            picktype = "Team"
            pickgame = games[:gamename]
            gamepick = "X"
          end
        end
        
      end
      
    end
    
    #open('json.out', 'w') { |f|
     # f.puts JSON.pretty_generate(firstjson)
      #f.puts JSON.pretty_generate(secondjson)}
      
      



    binding.pry
  end
end

  