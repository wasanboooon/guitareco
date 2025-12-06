class CreatePosts < ActiveRecord::Migration[7.2]
  def change
    create_table :posts do |t|
      t.string :number
      t.string :content

      t.timestamps
    end
  end
end
