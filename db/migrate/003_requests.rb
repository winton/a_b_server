class Requests < ActiveRecord::Migration
  def self.up
    create_table :requests do |t|
      t.string :agent
      t.boolean :found_duplicate
      t.string :identifier
      t.string :ip
      t.integer :visits, :default => 0
      t.integer :conversions, :default => 0
      t.string :visit_ids, :limit => 1024
      t.string :conversion_ids, :limit => 1024
      t.timestamps
    end
  end

  def self.down
    drop_table :requests
  end
end
