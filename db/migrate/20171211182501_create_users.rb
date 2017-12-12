class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :uid, null: false, unique: true, presence: true
      t.text :spotify_hash, presence: true
      t.string :name

      t.timestamps
    end
  end
end
