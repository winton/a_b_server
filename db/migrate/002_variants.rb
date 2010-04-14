class Variants < ActiveRecord::Migration
  def self.up
    create_table :variants do |t|
      t.string :name
      t.boolean :control, :default => false
      t.string :data, :limit => 4096
      t.integer :test_id
      t.timestamps
    end
    add_index :variants, :test_id
    add_index :variants, :control
    add_index :variants, :name
  end

  def self.down
    drop_table :variants
  end
end
