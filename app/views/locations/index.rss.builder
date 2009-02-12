xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "IceCondor locations for #{@locations.first.user.username}"
    xml.description "Continuous location tracking"
    xml.link root_url

    for location in @locations
      xml.item do
        xml.title "report from #{location.user.username}"
        xml.description "#{location.user.username} reported"
        xml.pubDate location.created_at.to_s(:rfc822)
        xml.link locations_url+"?id="+location.user.openidentities.first.url
        xml.georss :point, "#{location.latitude} #{location.longitude}"
      end
    end
  end
end

