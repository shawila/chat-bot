class CreateRaids < ActiveRecord::Migration
  def change
    create_table :raids do |t|
      t.belongs_to :guild, index: :true

      t.string :name

      t.timestamps null: false
    end
  end
end
