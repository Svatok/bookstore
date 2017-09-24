class AddSuperadminToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :role, :string

    User.create! do |u|
        u.email     = 'admin@admin.com'
        u.password    = 'Superadmin2017'
        u.role = 'admin'
    end

  end
end
