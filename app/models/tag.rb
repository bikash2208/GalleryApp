class Tag < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :albums, through: :taggings, dependent: :destroy
end
 