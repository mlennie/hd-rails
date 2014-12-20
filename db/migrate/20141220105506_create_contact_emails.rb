class CreateContactEmails < ActiveRecord::Migration
  def change
    create_table :contact_emails do |t|
      t.string :name
      t.integer :user_id
      t.string :email
      t.text :content
      t.boolean :archived

      t.timestamps
    end
    add_index :contact_emails, :user_id
  end
end
