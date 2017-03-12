ActiveAdmin.register Order do

  permit_params :total_price, :state, :order_number, :placed_date

  scope :processing, default: true
  scope :delivered
  scope :canceled
  scope :not_placed

  filter :order_number
  filter :total_price
  filter :state, as: :select, collection: proc { Order.aasm.states_for_select }
  filter :placed_date
  filter :updated_at

  actions :all, except: [:edit]

  index :as => ActiveAdmin::Views::IndexAsTable do
    selectable_column
    column :number, sortable: :order_number do |order|
      order.order_number
    end
    column :date_of_creation, sortable: :placed_date do |order|
      order.placed_date
    end
    column :date_of_update, sortable: :updated_at do |order|
      order.updated_at
    end
    column :state, sortable: :state do |order|
      column_select(order, :state, order.aasm.states(permitted: true).map(&:name) << order.state.to_sym)
    end
    column :total_price, sortable: :total_price do |order|
      number_to_currency(order.total_price,:unit=>'€')
    end
    actions
  end

  controller do
    def update
      super do
        redirect_back(fallback_location: root_path) and return
      end
    end
  end
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end


end
