class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :email
      t.string :encrypted_password
      t.string :name
      t.string :address
      t.string :phone_number
      t.string :before_field
      t.string :after_field

      t.timestamps
    end
  end
end
