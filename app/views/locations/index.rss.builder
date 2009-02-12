xml.instruct! :xml, :version => "1.0"
xml.rss(:version => "2.0", 
        "xmlns:geo".to_sym => "http://www.w3.org/2003/01/geo/wgs84_pos#") do
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
        xml.geo :lat, "#{location.latitude}"
        xml.geo :long, "#{location.longitude}"
      end
    end
  end
end

