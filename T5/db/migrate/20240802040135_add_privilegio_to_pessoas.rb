class AddPrivilegioToPessoas < ActiveRecord::Migration[7.1]
  def change
    add_column :pessoas, :privilegio, :integer, default: 1, null: false
  end
end
