class UserMailer < ActionMailer::Base
  def trigger_email(trigger, email, inout)
    recipients email 
    from "IceCondor Trigger <triggers@icecondor.com>"  
    subject "#{inout} #{trigger.fence.name}"  
    sent_on Time.now 
    body({:trigger => trigger, :inout => inout})
    attachment :content_type => "image/jpeg",  :body => HTTParty.get("http://maps.google.com/maps/api/staticmap?center=45.5,-122.5&zoom=14&size=256x256&sensor=false")
  end  
end
