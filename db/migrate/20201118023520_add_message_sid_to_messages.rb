class AddMessageSidToMessages < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :sid, :string
  end
end
