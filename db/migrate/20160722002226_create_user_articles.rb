class CreateUserArticles < ActiveRecord::Migration[5.0]
  def change
    create_table :user_articles do |t|
      t.references :user, foreign_key: true, null:false, index:true
      t.references :article, foreign_key: true, null:false, index:true
      t.boolean :listened, default:false

      t.timestamps null: false
    end
  end
end
