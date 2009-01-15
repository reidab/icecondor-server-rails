module XrdsHeader
  def self.included(base)
    base.send(:before_filter, :xrds_header)
  end

  def xrds_header
    response.headers['X-XRDS-Location'] = root_url + "xrds.xml"
  end 
end
