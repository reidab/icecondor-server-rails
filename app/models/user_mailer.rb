class UserMailer < ActionMailer::Base
  def trigger_email(trigger, email)
    recipients email 
    from "IceCondor Trigger <triggers@icecondor.com>"  
    subject "Trigger: #{trigger.name}"  
    sent_on Time.now 
    body({:trigger => trigger})
  end  
end
