class ChangeDataTypeForPercentage < ActiveRecord::Migration[5.2]
  def change
    change_column(:discounts, :percentage, :integer)
  end
end
