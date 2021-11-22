class CreateAwards < ActiveRecord::Migration[6.1]
  def change
    create_table :awards do |t|
      t.string :purpose
      t.decimal :cash_amount, precision: 10, scale: 2
      t.references :receiver
      t.references :filer

      t.timestamps
    end
  end
end
