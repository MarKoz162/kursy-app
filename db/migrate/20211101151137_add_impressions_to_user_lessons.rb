class AddImpressionsToUserLessons < ActiveRecord::Migration[6.1]
  def change
    add_column :user_lessons, :impressions, :integer, default: 0, nul: false
  end
end
