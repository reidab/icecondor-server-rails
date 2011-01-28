class Trigger < ActiveRecord::Base
  belongs_to :user
  belongs_to :fence  
  belongs_to :script
  before_create :default_values

  def default_values
    action ||= "email"
  end

  def check_location(location)
    if fence.contains?(location)
      if trigger!
        inside_action!(location)
        logger.info("trigger #{name}: fence #{fence.name}: TRIGGERED #{action} #{extra}")
      else
        logger.info("trigger #{name}: fence #{fence.name}: SILENT")
      end
    else
      if untrigger!
        outside_action!(location)
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

  def inside_action!(location)
    case action
    when "email"
      UserMailer.deliver_trigger_email(self, extra, "Inside", location)
    when "foursquare"
      user.foursquare.checkin({:vid => extra, :shout => fsq_shout})
    when "blur"
    end
  end

  def outside_action!(location)
    case action
    when "email"
      UserMailer.deliver_trigger_email(self, extra, "Outside", location)
    when "foursquare"
    when "blur"
    end
  end

  def extra_display
    case action
    when "foursquare"
      fsq_name
    when "script"
      if script
        script.name
      else
        "##{script_id} missing"
      end
    else extra
    end
  end

  def goog_static_map_url(location)
    params = ["center=#{location.latitude},#{location.longitude}",
              "zoom=14",
              "size=256x256",
              "sensor=false",
              "markers=color:green%7Clabel:X%7C#{location.latitude},#{location.longitude}",
              "path=color:0x00000000%7Cweight:5%7Cfillcolor:0x00FF0099%7C#{fence.geom.rings.first.points.map{|p|"#{p.y},#{p.x}"}.join("%7C")}"]
    "http://maps.google.com/maps/api/staticmap?#{params.join("&")}"
  end
end
