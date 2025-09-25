class CreateLinks < ActiveRecord::Migration[7.2]
  def change
    create_table :links do |t|
      t.string :name, null: false
      t.string :url, null: false
      t.belongs_to :linkable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
