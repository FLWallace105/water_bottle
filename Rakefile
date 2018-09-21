require 'dotenv'
Dotenv.load
require 'active_record'
require 'sinatra/activerecord/rake'
require_relative 'ellie_water_bottle_order'

namespace :water_bottle do
    desc 'set up customers for water bottle'
    task :list_subs do |t|
        ShopifyOrders::MakeBottleOrder.new.read_in_customers
    end

    desc 'push bottle orders to Shopify'
    task :push_bottle_orders do |t|
        ShopifyOrders::MakeBottleOrder.new.push_orders

    end



end