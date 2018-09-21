#ellie_water_bottle_order.rb
require 'shopify_api'
require 'dotenv'
require 'csv'
#Dotenv.load
require 'active_record'
require "sinatra/activerecord"
require_relative 'models/model'


module ShopifyOrders
    class MakeBottleOrder

        def initialize
            Dotenv.load
            @apikey = ENV['SHOPIFY_API_KEY']
            @shopname = ENV['SHOPIFY_SHOP_NAME']
            @password = ENV['SHOPIFY_PASSWORD']
        end

        def read_in_customers
            EllieBottleOrders.delete_all
            ActiveRecord::Base.connection.reset_pk_sequence!('ellie_bottle_orders')

            CSV.foreach('water_bottle_customers.csv', :encoding => 'ISO-8859-1', :headers => true) do |row|
                puts row.inspect
                my_email = row['Email']
                shipping_province = row['Shipping Province']
                shipping_country = row['Shipping Country']
                puts "-----"
                puts my_email
                my_customer = Customer.find_by_email(my_email)
                puts my_customer.inspect
                mynew_bottle_order = EllieBottleOrders.create(first_name: my_customer.first_name, last_name: my_customer.last_name, email: my_email, address1: my_customer.billing_address1, address2: my_customer.billing_address2, city: my_customer.billing_city, zip: my_customer.billing_zip, province: my_customer.billing_province, country: my_customer.billing_country, country_code: shipping_country,  province_code: shipping_province, phone: my_customer.billing_phone, shopify_customer_id: my_customer.shopify_customer_id)
            end 


        end

        def push_orders
            ShopifyAPI::Base.site = "https://#{@api_key}:#{@password}@#{@shopname}.myshopify.com/admin"
            myorders = EllieBottleOrders.where("order_sent = ?", false)

            myorders.each do |order|
                mycustomer = ShopifyAPI::Customer.find(order.shopify_customer_id)
                puts mycustomer.inspect
                my_address_info = mycustomer.attributes['default_address'].attributes['id']
                puts my_address_info.inspect
                puts "sleeping 4 seconds"
                create_order(my_address_info, order)

            end


        end


        def create_order(my_address_info, order)
            
            ShopifyAPI::Base.site = "https://#{@api_key}:#{@password}@#{@shopname}.myshopify.com/admin"
            puts "my_address_info = #{my_address_info}"
            puts "my order info = #{order.inspect}"
            
            name = "#{order.first_name} #{order.last_name}"
            

            myorder = ShopifyAPI::Order.new(
                :email => order.email,
                :gateway => "",
                :test => false,
                :total_price => "0.00",
                :subtotal_price => "0.00",
                :total_weight => 907,
                :total_tax => "0.00",
                :taxes_included => false,
                :currency => "USD",
                :financial_status => "paid",
                :confirmed => true,
                :total_discounts => "0.00",
                :total_line_items_price => "0.00",
                :cart_token => nil,
                :buyer_accepts_marketing => false,

                :total_price_usd => "0.00",
                :discount_applications => [],
                :discount_codes => [],
                :note_attributes => [],
                :contact_email => order.email,

                :line_items => [
                  ShopifyAPI::LineItem.new(
                    :quantity => 1,
                    :variant_id => 29222609042,
                    :title => "750ml Rose Gold Bottle",
                    :price => "0.00",
                    :sku => "722457706419",
                    :variant_title => "ONE SIZE / ROSE GOLD",
                    :vendor => "EllieActive",
                    :fulfillment_service => "manual",
                    :product_id => 8708750226,
                    :requires_shipping => true,
                    :taxable => true,
                    :gift_card => false,
                    :pre_tax_price => "0.00",
                    :name => "750ml Rose Gold Bottle - ONE SIZE / ROSE GOLD",
                    :variant_inventory_management => "shopify",
                    :properties => [],
                    :product_exists => true,
                    :fulfillable_quantity => 0,
                    :grams => 0,
                    :total_discount => "0.00",
                    :fulfillment_status => nil,
                    :discount_allocations => [],
                    :tax_lines => []
                  )
                ],
                :shipping_lines => [
                    {
                      "title" => "Free Shipping (5-9 days)",
                      "price" => "0.00",
                      "code" => "Free Shipping (5-9 days)",
                      "source" => "",
                      "phone" => nil,
                      "requested_fulfillment_service_id" => nil,
                      "delivery_category" => nil,
                      "carrier_identifier" => nil,
                      "discounted_price" => "0.00",
                      "discount_allocations" => [],
                      "tax_lines" => []
                    }
                  ],
                  :billing_address => {
                    "first_name" => order.first_name,
                    "address1" => order.address1,
                    "phone" => order.phone,
                    "city" => order.city,
                    "zip" => order.zip,
                    "province" => order.province,
                    "country" => order.country,
                    "last_name" => order.last_name,
                    "address2" => order.address2,
                    "company" => "",
                    "name" => name,
                    "country_code" => order.country_code,
                    "province_code" => order.province_code
                  },
                  :shipping_address => {
                    "first_name" => order.first_name,
                    "address1" => order.address1,
                    "phone" => order.phone,
                    "city" => order.city,
                    "zip" => order.zip,
                    "province" => order.province,
                    "country" => order.country,
                    "last_name" => order.last_name,
                    "address2" => order.address2,
                    "company" => "",
                    "name" => name,
                    "country_code" => order.country_code,
                    "province_code" => order.province_code
                  },
                  :fulfillments => [],
                  :customer => {
                    "id": order.shopify_customer_id,
                    "email": order.email,
                    "accepts_marketing": false,
                    "first_name": order.first_name,
                    "last_name": order.last_name,
                    "state": "enabled",
                    "note": "Make good for first time subscriber water bottle",
                    "verified_email": true,
                    "multipass_identifier": nil,
                    "tax_exempt": false,
                    "default_address": {
                      "id": my_address_info,
                      "customer_id": order.shopify_customer_id,
                      "first_name": order.first_name,
                      "last_name": order.last_name,
                      "company": "",
                      "address1": order.address1,
                      "address2": order.address2,
                      "city": order.city,
                      "province": order.province,
                      "country": order.country,
                      "zip": order.zip,
                      "phone": order.phone,
                      "name": name,
                      "province_code": order.province_code,
                      "country_code": order.country_code,
                      "country_name": order.country,
                      "default": true
                    }
                  }

              )
            
            puts myorder.inspect
            myorder.save
            puts "-----------------"
            puts myorder.inspect
            order.order_sent = true
            order.order_date = DateTime.now.strftime("%Y-%m-%d %H:%M:%S")
            order.save
            puts "sleeping 4 secs"
            sleep 4

        

        end

    end
end