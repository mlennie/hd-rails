class CreatePreSubscribers < ActiveRecord::Migration
  def change
    create_table :pre_subscribers do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.boolean :archived

      t.timestamps
    end
  end
end
