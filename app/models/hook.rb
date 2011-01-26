class Hook < ActiveRecord::Base
  belongs_to :target, :polymorphic => true
end
