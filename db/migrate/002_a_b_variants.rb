class ABVariants < ActiveRecord::Migration
  def self.up
    create_table :a_b_variants do |t|
      t.string :name
      t.integer :conversions
      t.integer :visitors
    end
  end

  def self.down
    drop_table :a_b_variants
  end
end
