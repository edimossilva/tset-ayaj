class GithubWebhooksController < ActionController::Base
  skip_before_action :verify_authenticity_token

  # Handle push event
  def create
    binding.pry
    puts params
  end

end