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
        inside_action!
        logger.info("trigger #{name}: fence #{fence.name}: TRIGGERED #{action} #{extra}")
      else
        logger.info("trigger #{name}: fence #{fence.name}: SILENT")
      end
    else
      if untrigger!
        outside_action!
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

  def inside_action!
    case action
    when "email"
      UserMailer.deliver_trigger_email(self, extra, "Inside")
    when "foursquare"
      user.foursquare.checkin({:vid => extra, :shout => fsq_shout})
    when "blur"
    end
  end

  def outside_action!
    case action
    when "email"
      UserMailer.deliver_trigger_email(self, extra, "Outside")
    when "foursquare"
    when "blur"
    end
  end

  def extra_display
    case action
    when "foursquare"
      fsq_name
    else extra
    end
  end
end
