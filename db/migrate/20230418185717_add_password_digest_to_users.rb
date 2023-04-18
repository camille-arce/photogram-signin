class AddPasswordDigestToUsers < ActiveRecord::Migration[6.0]
  def change
    #          :table   :column           :type
    add_column :users, :password_digest, :string
  end
end
