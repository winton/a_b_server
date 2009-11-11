class ABVariants < ActiveRecord::Migration
  def self.up
    create_table :a_b_variants do |t|
      t.string :name
      t.boolean :control, :default => false
      t.integer :conversions, :default => 0
      t.integer :visitors, :default => 0
      t.integer :a_b_test_id
      t.timestamps
    end
    add_index :a_b_variants, :a_b_test_id
    add_index :a_b_variants, :control
    add_index :a_b_variants, :name
  end

  def self.down
    drop_table :a_b_variants
  end
end
