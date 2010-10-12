class UserMailer < ActionMailer::Base
  def trigger_email(trigger, email, inout)
    recipients email 
    from "IceCondor Trigger <triggers@icecondor.com>"  
    subject "#{inout} #{trigger.fence.name}"  
    sent_on Time.now 
    body({:trigger => trigger, :inout => inout})
  end  
end
