class AddCatagoryForeignKey < ActiveRecord::Migration
  def change
     add_column :reviews, :category_id, :integer
  end
end
