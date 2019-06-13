class AddActionsToIssues < ActiveRecord::Migration[5.2]
  def change
    add_column :issues, :action, :integer
  end
end
