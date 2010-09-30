class TriggersController < ApplicationController

  def index
  end

  def new
  end

  def create
    trigger = current_user.triggers.create(params[:trigger])
    redirect_to edit_trigger_path(trigger)
  end

  def edit
    @trigger = Trigger.find(params[:id])
  end

  def update
    trigger = Trigger.find(params[:id])
    trigger.update_attributes(params[:trigger])
    trigger.save!
    redirect_to edit_trigger_path(trigger)
  end

  def destroy
    Trigger.find(params[:id]).destroy
    redirect_to {:controller => :users, :action => :show, :id => current_user.username}
  end
end
