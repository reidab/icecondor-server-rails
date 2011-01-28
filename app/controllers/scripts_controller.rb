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
    flash[:notice] = "Saved!"
    redirect_to edit_script_path(@script)
  end

  def destroy
    @script = Script.find(params[:id].to_i)
    @script.destroy
    redirect_to({:controller => :users, :action => :show,
                 :id => current_user.username})
  end

  def run
    require 'v8'
    @script = Script.find(params[:id].to_i)
    cxt = V8::Context.new
    begin
      @result = cxt.eval(@script.code)
    rescue V8::JSError => e
      @error = e
    end
  end
end