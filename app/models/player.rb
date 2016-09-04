class Player < ActiveRecord::Base
  has_many :picks
  has_many :awards
end
