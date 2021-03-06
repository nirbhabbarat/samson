class WebhooksController < ApplicationController
  before_filter :authorize_deployer!
  before_filter :find_project

  def index
    @webhooks = @project.webhooks
  end

  def new
    @webhooks = @project.webhooks
  end

  def create
    @project.webhooks.create!(webhook_params)

    redirect_to project_webhooks_path(@project)
  end

  def destroy
    webhook = @project.webhooks.find(params[:id])
    webhook.destroy

    redirect_to project_webhooks_path(@project)
  end

  def show
    @webhook = @project.webhooks.find(params[:id])
  end

  private

  def find_project
    @project = Project.find_by_param!(params[:project_id])
  end

  def webhook_params
    params.require(:webhook).permit(:branch, :stage_id)
  end

end
