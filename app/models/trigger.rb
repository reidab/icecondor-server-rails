class Trigger < ActiveRecord::Base
  belongs_to :user
  belongs_to :fence  
  before_create :default_values

  def default_values
    action ||= "email"
  end

  def check_location(location)
    unless triggered?
      if fence.contains?(location)
        trigger!
        logger.info("trigger #{name}: fence #{fence.name}: TRIGGERED #{action} #{extra}")
      else
        logger.info("trigger #{name}: fence #{fence.name}: SILENT")
      end
    end
  end

  def triggered?
    !!triggered_at
  end

  def trigger!(now=Time.now)
    unless triggered?
      update_attribute :triggered_at, now
      UserMailer.deliver_trigger_email(self, extra)
    end
  end
end
