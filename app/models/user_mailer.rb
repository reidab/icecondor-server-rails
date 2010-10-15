class UserMailer < ActionMailer::Base
  def trigger_email(trigger, email, inout, location)
    recipients email 
    from "IceCondor Trigger <triggers@icecondor.com>"  
    subject "#{inout} #{trigger.fence.name}"  
    content_type "multipart/mixed"

    part "text/html" do |p| 
      p.body = render_message("trigger_email", :message => "<h1>HTML content</h1>")  
    end  

    part "text/plain" do |p| 
      p.body = render_message("trigger_email", :message => "text content")  
    end 

    attachment :content_type => "image/jpeg",  :body => HTTParty.get("http://maps.google.com/maps/api/staticmap?center=45.5,-122.5&zoom=14&size=256x256&sensor=false"), :content_location => "map.jpg"
  end  
end
