class AddReportFieldToTable < ActiveRecord::Migration
  def change
      add_column :users, :reported, :string, :default => '0'
      add_column :reviews, :reported, :string, :default => '0'
      add_column :ratings, :reported, :string, :default => '0'
  end
end
