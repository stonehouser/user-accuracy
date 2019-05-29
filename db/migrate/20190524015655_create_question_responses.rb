class CreateQuestionResponses < ActiveRecord::Migration[5.2]
  def change
    create_table :question_responses do |t|
      t.references :user, null: false, index: true, foreign_key: true
      t.boolean :correct, null: false, default: false
      t.datetime :created_at, null: false
    end
    add_index :question_responses, [:user_id, :created_at]
  end
end
