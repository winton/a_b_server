class Variants < ActiveRecord::Migration
  def self.up
    create_table :variants do |t|
      t.string :name
      t.boolean :control, :default => false
      t.integer :conversions, :default => 0
      t.integer :visits, :default => 0
      t.string :extras, :limit => 2048
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
