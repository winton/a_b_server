class Categories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string :name
      t.integer :user_id
    end
  end

  def self.down
    drop_table :categories
  end
end
