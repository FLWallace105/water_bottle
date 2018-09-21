class Subscription < ActiveRecord::Base
    self.table_name = "subscriptions"
end

class Customer < ActiveRecord::Base
    self.table_name = "customers"
end


class EllieBottleOrders < ActiveRecord::Base
    self.table_name = "ellie_bottle_orders"
end