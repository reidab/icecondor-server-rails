class FencesController < ApplicationController
  def new
    respond_to do |wants|
      wants.html { }
    end
  end

  def create
    render :text => params.inspect
  end
end
