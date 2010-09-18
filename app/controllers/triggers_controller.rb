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
end
