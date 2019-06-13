class IssueSerializer < ActiveModel::Serializer
  attributes :action, :created_at
  def action
    Issue.actions.key(object.action)
  end
end
