class CreatePreferences < ActiveRecord::Migration
  def change
    create_table :preferences do |t|
      t.integer :user_id
      t.boolean :archived, default: false
      t.boolean :receive_emails, default: true

      t.timestamps
    end
    add_index :preferences, :user_id
    add_index :preferences, :archived
  end
end
