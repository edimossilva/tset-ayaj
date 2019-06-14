require 'rails_helper'

RSpec.describe Issue, :type => :model do
  it "is valid with valid attribute" do
    issue = Issue.new
    issue.action = Issue.actions['open']
    expect(issue).to be_valid
  end

  it "is not valid with invalid attribute" do
    issue = Issue.new
    issue.action = Issue.actions['invalid_attribute']
    expect(issue).to_not be_valid
  end

  it "is not valid with empty attribute" do
    expect(Issue.new).to_not be_valid
  end

end