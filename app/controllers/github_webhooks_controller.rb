class GithubWebhooksController < ActionController::Base
  skip_before_action :verify_authenticity_token

  before_action :validate_params, only: [:create]

  def create
    issue = Issue.new
    issue.action = Issue.actions[issue_state]

    if (issue.save)
      render json: issue, status: :created
    else
      render json: {errors: issue.errors}, status: :unprocessable_entity
    end
  end

  def index
    render json: Issue.all, status: :ok
  end

  private

  def validate_params
    unless (valid_params?)
      render json: {}, status: :bad_request
    end
  end

  def valid_params?
    params[:issue].present? &&
    params[:issue][:state].present?
  end

  def issue_state
    params[:issue][:state]
  end
end
