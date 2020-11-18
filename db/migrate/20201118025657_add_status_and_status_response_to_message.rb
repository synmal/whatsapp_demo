class AddStatusAndStatusResponseToMessage < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :status, :string
    add_column :messages, :status_response, :jsonb
  end
end
