class BottleOrders < ActiveRecord::Migration[5.2]
  def up
    create_table :ellie_bottle_orders do |t|
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :address1
      t.string :address2
      t.string :city
      t.string :zip
      t.string :province
      t.string :province_code
      t.string :country
      t.string :country_code
      t.string :phone
      t.bigint :shopify_customer_id
      t.bigint :shopify_address_id
      t.boolean :order_sent, :default => false
      t.datetime :order_date
    end
  end

  def down
    drop_table :ellie_bottle_orders
  end
end
