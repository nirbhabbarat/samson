require_relative '../test_helper'

describe ApplicationHelper do
  describe "#deploy_link" do
    let(:project) { projects(:test) }
    let(:stage) { stages(:test_staging) }
    let(:link) { deploy_link(project, stage) }
    let(:current_user) { users(:admin) }

    it "starts a deploy" do
      assert_includes link, ">Deploy<"
      assert_includes link, %{href="/projects/#{project.to_param}/deploys/new?stage_id=#{stage.id}"}
    end

    it "shows locked" do
      stage.stubs(locked_for?: true)
      assert_includes link, ">Locked<"
    end

    it "shows running deploy" do
      deploy = stage.deploys.create!(
        reference: 'master',
        job: Job.create(user: current_user, command: '', project: project)
      )
      stage.stubs(current_deploy: deploy)
      assert_includes link, ">Deploying master...<"
      assert_includes link, %{href="/projects/#{project.to_param}/deploys/#{deploy.id}"}
    end
  end
end
