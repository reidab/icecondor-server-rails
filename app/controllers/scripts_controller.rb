class ScriptsController < ApplicationController
  def create
    script = current_user.scripts.create!
    redirect_to edit_script_path(script)
  end

  def edit
    @script = Script.find(params[:id].to_i)
  end

  def update
    @script = Script.find(params[:id].to_i)
    @script.attributes = params[:script]
    @script.save!
    redirect_to edit_script_path(@script)
  end
end
