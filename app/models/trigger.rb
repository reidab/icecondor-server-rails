class Trigger < ActiveRecord::Base
  belongs_to :user
  belongs_to :fence  
  before_create :default_values

  def default_values
    action ||= "email"
  end

  def check_location(location)
    if fence.contains?(location)
      if trigger!
        action!
        logger.info("trigger #{name}: fence #{fence.name}: TRIGGERED #{action} #{extra}")
      else
        logger.info("trigger #{name}: fence #{fence.name}: SILENT")
      end
    else
      if untrigger!
        logger.info("trigger #{name}: fence #{fence.name}: RESET")
      end
    end
  end

  def triggered?
    !!triggered_at
  end

  def trigger!(now=Time.now)
    unless triggered?
      update_attribute :triggered_at, now
    end
  end

  def untrigger!
    if triggered?
      update_attribute :triggered_at, nil
    end
  end

  def action!
    UserMailer.deliver_trigger_email(self, extra)
  end
end
