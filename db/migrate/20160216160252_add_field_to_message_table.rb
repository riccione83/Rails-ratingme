class AddFieldToMessageTable < ActiveRecord::Migration
  def change
    add_column :messages, :long_text, :string
    add_column :messages, :notify, :integer
  end
end
