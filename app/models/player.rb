class Player < ActiveRecord::Base
  has_many :picks
  has_many :awards
  
  after_create do
        User.find_by(name: self.playername).try(:update, {"cbs_id" => self.cbsid})

  end
  
  after_update do
        User.find_by(cbs_id: self.cbsid).try(:update, {"name" => self.playername})

  end
  
  
end
