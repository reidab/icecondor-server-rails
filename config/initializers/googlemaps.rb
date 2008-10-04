#
# Set GOOGLE_APPLICATION_ID for the maps plugin.
#
# config/googlemaps.yml should look like:
#
# development: 
#  # A key from the gmaps_on_rails plugin's readme, for "http://localhost:3000/"
#  google: "ABQIAAAA3HdfrnxFAPWyY-aiJUxmqRTJQa0g3IQ9GZqIMmInSLzwtGDKaBQ0KYLwBEKSM7F9gCevcsIf6WPuIQ"
#
#production: 
#  google: "<key goes here>"

keys_path = "#{RAILS_ROOT}/config/googlemaps.yml"
if File.exist? keys_path
  mapkeys = YAML.load_file(keys_path)
  GOOGLE_APPLICATION_ID = mapkeys.fetch(Rails.env,{})['google']
end

