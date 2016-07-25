class AddColTitleToArticle < ActiveRecord::Migration[5.0]
  add_column :articles, :title, :string
end
