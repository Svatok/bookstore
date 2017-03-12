ActiveAdmin.register Review do

  permit_params :product_id, :created_at, :reviewer_name, :status, :rate, :review_text

  scope :unprocessed, default: true
  scope :processed

  filter :status, as: :select, collection: ['approved', 'rejected']
  filter :created_at
  filter :product
  filter :rate
  filter :reviewer_name
  filter :review_text

  actions :all, except: [:edit]

  index :as => ActiveAdmin::Views::IndexAsTable do
    selectable_column
    column :product do |review|
      review.product
    end
    column :date_of_creation, sortable: :created_at do |review|
      review.created_at
    end
    column :reviewer, sortable: :reviewer_name do |review|
      review.reviewer_name
    end
    column :status, sortable: :status do |review|
      review.status
    end
    column :rate, sortable: :rate do |review|
      review.rate
    end
    column :review_text, sortable: false do |review|
      truncate(review.review_text, length: 100)
    end
    actions defaults: true do |review|
      link_to('Approve', admin_review_path(review, params.permit(:status).merge(status: 'approved')), html_options = {'data-method' => 'put'}) +
      ' ' +
      link_to('Reject', admin_review_path(review, params.permit(:status).merge(status: 'rejected')), html_options = {'data-method' => 'put'})
    end
  end

  controller do
    def update
      review = Review.find(params[:id])
      review.update_attributes(status: params['status']) if params['status'].present?
      redirect_back(fallback_location: root_path)
    end
  end

  # controller do
  #   def scoped_collection
  #     resource_class.includes(:product) # prevents N+1 queries to your database
  #   end
  # end
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
