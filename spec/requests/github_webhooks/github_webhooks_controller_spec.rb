require 'rails_helper'
describe "GithubWebhooksController", :type => :request do
  let!(:open_issues_count) { 10 }
  let!(:closed_issues_count) { 10 }
  let!(:total_issues_count) {open_issues_count + closed_issues_count}
  context '#index' do
    context 'When database contains a issues list' do
      before(:each) do
        FactoryBot.create_list(:issues,  open_issues_count, :open)
        FactoryBot.create_list(:issues,  closed_issues_count, :closed)
        get '/github_webhooks'
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(:success)
      end

      it 'has issues amount equals to all issues amount' do
        issueList = JSON.parse(response.body)
        expect(issueList.count).to eq(total_issues_count)
      end
    end

    context 'When database does not contains a issues list' do
      before(:each) do
        get '/github_webhooks'
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(:success)
      end

      it 'has issues amount equals to zero' do
        issueList = JSON.parse(response.body)
        expect(issueList.count).to eq(0)
      end
    end
  end

end