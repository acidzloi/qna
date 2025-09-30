class CreateVotes < ActiveRecord::Migration[7.2]
  def change
    create_table :votes do |t|
      t.integer :vote, null: false, default: 0
      t.references :voteble, polymorphic: true, null: false
      t.references :user, foreign_key: true, null: false
      
      t.timestamps
    end
  end
end
