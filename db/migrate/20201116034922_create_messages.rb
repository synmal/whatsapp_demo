class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.string :type
      t.text :body
      t.jsonb :twilio_response
      t.references :recipient, null: false, foreign_key: true

      t.timestamps
    end
  end
end
