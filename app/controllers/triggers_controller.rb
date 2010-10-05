class TriggersController < ApplicationController

  def index
  end

  def new
    @fence = current_user.fences.find(params[:fence_id])
    @trigger = current_user.triggers.build(params[:trigger])
  end

  def create
    trigger = current_user.triggers.create(params[:trigger])
    redirect_to edit_trigger_path(trigger)
  end

  def edit
    @trigger = current_user.triggers.find(params[:id])
  end

  def reset
    @trigger = current_user.triggers.find(params[:id])
    @trigger.untrigger!
    redirect_to({:controller => :users, :action => :show, :id => current_user.username})
  end

  def update
    trigger = current_user.triggers.find(params[:id])
    trigger.update_attributes(params[:trigger])
    trigger.save!
    redirect_to ({:controller => :users, :action => :show, :id => current_user.username})
  end

  def destroy
    current_user.triggers.find(params[:id]).destroy
    redirect_to({:controller => :users, :action => :show, :id => current_user.username})
  end
end
