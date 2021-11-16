class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :email
      t.string :encrypted_password
      t.string :name
      t.string :address
      t.string :phone_number

      t.timestamps
    end
  end
end
