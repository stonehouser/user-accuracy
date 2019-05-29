class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :username, null: false, index: { unique: true }
      t.string :timezone, null: false
      t.datetime :created_at, null: false
    end
  end
end
