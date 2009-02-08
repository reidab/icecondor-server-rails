require File.dirname(__FILE__) + '/../../spec_helper'

describe "/dashboard/index" do
  it "should render valid XHTML" do
    assigns[:locations] = []
    template.should_receive(:google_map)
    render "/dashboard/index"
    response.should have_tag('div.heading')
  end
end
