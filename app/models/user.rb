class User < ActiveRecord::Base
  validates :name, presence: true, uniqueness: {:case_sensitive => false, :message => lambda{|x,y| "\"#{y[:value]}\" is already assigned to another user"}}
  validate :name_must_exist
   
  has_secure_password
  
  def name_must_exist
    if Player.where("lower(playername) = ?", name.downcase).count == 0
      errors.add(name, "is not a valid team name")
     
    end
  end
 

    before_create do
        p = Player.find_by("lower(playername) = ?", self.name.downcase)
        
        if p != nil
          self.cbs_id = p.cbsid
          self.name = p.playername
        end
    end
  
end
