class CreateGuitarTypes < ActiveRecord::Migration[7.2]
  def change
    create_table :guitar_types do |t|
      t.string :code
      t.string :name
      t.text :description
      t.text :recommended_styles
      t.string :low_price_model
      t.string :mid_price_model
      t.string :high_price_model
      t.string :similar_type_code

      t.timestamps
    end
  end
end
