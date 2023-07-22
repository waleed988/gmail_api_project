class CreateMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :messages do |t|
      t.string :from
      t.string :subject
      t.string :to
      t.string :cc

      t.timestamps
    end
  end
end
