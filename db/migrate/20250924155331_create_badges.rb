class CreateBadges < ActiveRecord::Migration[7.2]
  def change
    create_table :badges do |t|
      t.string :title, null: false
      t.belongs_to :question, foreign_key: true, null: false
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end
