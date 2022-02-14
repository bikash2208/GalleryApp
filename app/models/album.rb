class Album < ApplicationRecord
  belongs_to :user
  has_one_attached :album_pic
  has_many_attached :images
  has_many :taggings,dependent: :destroy
  has_many :tags, through: :taggings, dependent: :destroy

  validates :title, presence: true, length: { minimum: 3}
  validates :description, presence: true, length: {minimum: 10,message: " greater then 10 charracters"}
  validates :album_tags, presence: true,length: {minimum: 3}
  validates :album_pic,attached: true,content_type: { in: [:png, :jpg, :jpeg], message: 'is not in jpg, jpeg, png formate' }
  validates :images,content_type: { in: [:png, :jpg, :jpeg], message: 'is not in jpg, jpeg, png formate' }

  def album_tags=(names)
    self.tags= names.split(",").map do |name|
      Tag.where(name: name.strip.downcase).first_or_create!
    end
  end

  def album_tags
    self.tags.map(&:name).join(", ")
  end
end
 