class CreatePreSubscribers < ActiveRecord::Migration
  def change
    create_table :pre_subscribers do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.boolean :archived, default: false

      t.timestamps
    end
  end
end
