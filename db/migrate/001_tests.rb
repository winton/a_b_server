class Tests < ActiveRecord::Migration
  def self.up
    create_table :tests do |t|
      t.string :name
      t.string :ticket_url
      t.integer :category_id
      t.timestamps
    end
    add_index :tests, :name
  end

  def self.down
    drop_table :tests
  end
end
