class GithubWebhooksController < ActionController::Base
  skip_before_action :verify_authenticity_token

  # Handle push event
  def create
    issue = Issue.new
    issue_state = params['issue']['state']
    issue.action = Issue.actions[issue_state]
    issue.save
    binding.pry
  end

  def index
    render json: Issue.all
  end

end
