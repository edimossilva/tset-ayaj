require 'rails_helper'
describe "GithubWebhooksController", :type => :request do
  context '#index' do
    let!(:open_issues_count) { 10 }
    let!(:closed_issues_count) { 10 }
    let!(:total_issues_count) {open_issues_count + closed_issues_count}

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

  context '#create' do
    context 'When required issue params are present' do
      context 'When params are valid' do
        context 'When open issue is created' do
          let!(:open) { 'open' }
          before(:each) do
            open_issue_params = {
              'issue': {
                'state':open
              }
            }
            post github_webhooks_path open_issue_params
          end

          it 'returns status code created' do
            expect(response).to have_http_status(:created)
          end

          it 'creates an open issue' do
            response_body_json = JSON.parse(response.body)
            expect(response_body_json['action']).to eq(open)
          end
        end
        context 'When closed issue is created' do
          let!(:closed) { 'closed' }
          before(:each) do
            closed_issue_params = {
              'issue': {
                'state':closed
              }
            }
            post github_webhooks_path closed_issue_params
          end

          it 'returns status code created' do
            expect(response).to have_http_status(:created)
          end

          it 'creates a closed issue' do
            response_body_json = JSON.parse(response.body)
            expect(response_body_json['action']).to eq(closed)
          end
        end
      end
      context 'When params are not valid' do
        context 'When state is not valid' do
          let!(:invalid_state) { 'invalid_state' }
          before(:each) do
           invalid_state_params = {
              'issue': {
                'state':invalid_state
              }
            }
            post github_webhooks_path invalid_state_params
          end

          it 'returns status code unprocessable_entity' do
            expect(response).to have_http_status(:unprocessable_entity)
          end

          it 'does not create issue' do
            expect(Issue.all).to be_empty
          end
        end
      end
    end
    context 'When required params are missing' do
      context 'When issue param is missing' do
        before(:each) do
          issue_missing_params = {
            'not_a_issue': {
              'state':'open'
            }
          }
          post github_webhooks_path issue_missing_params
        end

        it 'returns status code bad_request' do
          expect(response).to have_http_status(:bad_request)
        end

        it 'does not create issue' do
          expect(Issue.all).to be_empty
        end
      end
      context 'When state param is missing' do
        before(:each) do
          issue_missing_params = {
            'issue': {
              'not_a_state':'open'
            }
          }
          post github_webhooks_path issue_missing_params
        end

        it 'returns status code bad_request' do
          expect(response).to have_http_status(:bad_request)
        end

        it 'does not create issue' do
          expect(Issue.all).to be_empty
        end
      end
    end
  end
end
