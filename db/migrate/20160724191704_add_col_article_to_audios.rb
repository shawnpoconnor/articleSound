class AddColArticleToAudios < ActiveRecord::Migration[5.0]
  add_reference :audios, :article, index: true
end
