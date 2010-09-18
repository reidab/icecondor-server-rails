class Trigger < ActiveRecord::Base
  belongs_to :user
  belongs_to :fence  
end
