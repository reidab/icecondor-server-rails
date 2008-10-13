module MapHelper
  DEFAULT_CENTER = [45.523037,-122.667637]
  DEFAULT_ZOOM = 11

  # Return markup containing a Google map with markers for these Locations, 
  # or a default map if no locations are present. "locations" can be one 
  # item or an array of them.
  #
  # The plugin uses Google Maps automatic zooming to set the scale, but
  # the little overview map obscures such a big chunk of the main map that
  # it's likely to hide some of our markers, so it's off by default.
  def google_map(locations, options={})
    return nil if defined?(GoogleMap::GOOGLE_APPLICATION_ID) == nil
    height = options.delete(:height)
    width = options.delete(:width)
    partial = options.delete(:partial)
    options[:controls] ||= [:zoom, :scale, :type] # the default, minus :overview

    locations = [locations].flatten.select { |location| location.valid_location? }
    if locations.empty?
      options[:center] = DEFAULT_CENTER
      options[:zoom] = DEFAULT_ZOOM
    end

    # Make the map and our marker(s)
    map = GoogleMap.new(options)
    colors = ['red', 'blue', 'orange', 'yellow', 'black', 'brown', 'green']
    locations.each do |location|
      icon = GoogleMapSmallIcon.new(colors[location.guid.hash % colors.size])
      html = render(:partial => partial, :object => location) if partial
      map.markers << GoogleMapMarker.new(:map => map,
        :lat => location.latitude, :lng => location.longitude,
        :html => html, :icon => icon)
    end
    map.to_html + map.div(width, height)
  end
end
