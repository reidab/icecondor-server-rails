class UserMailer < ActionMailer::Base
  def trigger_email(trigger, email, inout, location)
    recipients email 
    from "IceCondor Trigger <triggers@icecondor.com>"  
    subject "#{inout} #{trigger.fence.name}"  

    part "text/html" do |p| 
      p.body = render_message("trigger_email", :trigger => trigger, :inout => inout, :location => location)  
    end  

    part "text/plain" do |p| 
      p.body = render_message("trigger_email", :trigger => trigger, :inout => inout, :location => location)  
    end 

    attachment :content_type => "image/jpeg",  :body => HTTParty.get("http://maps.google.com/maps/api/staticmap?center=#{location.latitude},#{location.longitude}&zoom=14&size=256x256&sensor=false"), :content_location => "map.jpg"
  end  
end
