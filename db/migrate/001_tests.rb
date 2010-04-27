class Tests < ActiveRecord::Migration
  def self.up
    create_table :tests do |t|
      t.string :name
      t.string :ticket_url
      t.integer :category_id
      t.integer :site_id
      t.integer :user_id
      t.timestamps
    end
    add_index :tests, :name
    add_index :tests, :category_id
    add_index :tests, :user_id
  end

  def self.down
    drop_table :tests
  end
end
