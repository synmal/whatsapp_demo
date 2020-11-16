class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.string :message_type
      t.text :body
      t.jsonb :twilio_response, default: {}
      t.references :recipient, null: false, foreign_key: true

      t.timestamps
    end
  end
end
