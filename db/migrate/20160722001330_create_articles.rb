class CreateArticles < ActiveRecord::Migration[5.0]
  def change
    create_table :articles do |t|
      t.text :text, null:false
      t.string :url, null:false
      t.string :domain, null:false
      t.string :aws_url

      t.timestamps null:false
    end
  end
end
