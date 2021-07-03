class CreateOptions < ActiveRecord::Migration[5.2]
  def change
    create_table :options do |t|
      t.string :name, null: false
      t.string :content, null: false

    end
  end
end
