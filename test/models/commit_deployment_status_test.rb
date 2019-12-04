require 'test_helper'

module Shipit
  class CommitDeploymentStatusTest < ActiveSupport::TestCase
    setup do
      @status = shipit_commit_deployment_statuses(:shipit2_deploy_third_in_progress)
      @deployment = @status.commit_deployment
      @task = @deployment.task
      @commit = @deployment.commit
      @author = @deployment.author
    end

    test 'creation on GitHub' do
      response = stub(id: 44, url: 'https://example.com')
      @author.github_api.expects(:create_deployment_status).with(
        @deployment.api_url,
        'in_progress',
        accept: "application/vnd.github.flash-preview+json",
        target_url: "http://shipit.com/shopify/shipit-engine/production/deploys/#{@task.id}",
        description: "walrus triggered the deploy of shopify/shipit-engine/production to #{@commit.sha}",
      ).returns(response)

      @status.create_on_github!
      assert_equal response.id, @status.github_id
      assert_equal response.url, @status.api_url
    end
  end
end
