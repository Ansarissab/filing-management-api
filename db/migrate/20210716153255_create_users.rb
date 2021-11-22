class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :ein, limit: 20
      t.string :name, limit: 100
      t.string :address, limit: 200
      t.string :city, limit: 100
      t.string :state, limit: 50
      t.string :zip_code, limit: 10
      t.string :type, limit: 50

      t.timestamps
    end
  end
end
