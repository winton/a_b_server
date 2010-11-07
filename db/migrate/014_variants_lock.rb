class VariantsLock < ActiveRecord::Migration
  def self.up
    add_column :variants, :lock_version, :integer, :default => 0
  end

  def self.down
    remove_column :variants, :lock_version
  end
end
