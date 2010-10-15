class UserMailer < ActionMailer::Base
  def trigger_email(trigger, email, inout, location)
    recipients email 
    from "IceCondor Trigger <triggers@icecondor.com>"  
    subject "#{inout} #{trigger.fence.name}"  
    content_type "multipart/alternative"

    part "text/html" do |p| 
      p.body = render_message("trigger_email", :trigger => trigger, :inout => inout, :location => location)  
    end  

    part "text/plain" do |p| 
      p.body = render_message("trigger_email", :trigger => trigger, :inout => inout, :location => location)  
    end 

    attachment :content_type => "image/jpeg",  :body => HTTParty.get(trigger.goog_static_map_url(location)), :content_location => "map.jpg"
  end  
end
