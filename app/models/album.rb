class Album < ApplicationRecord
  belongs_to :user
  has_one_attached :album_pic
  has_many_attached :images
  has_many :taggings,dependent: :destroy
  has_many :tags, through: :taggings, dependent: :destroy

  validates :title, presence: true
  validates :description, presence: true
  validates :album_tags, presence: true
  validates :album_pic,attached: true, content_type: [:png, :jpg, :jpeg]
  validates :images,content_type: [:png, :jpg, :jpeg]

  def album_tags=(names)
    self.tags= names.split(",").map do |name|
      Tag.where(name: name.strip).first_or_create!
    end
  end

  def album_tags
    self.tags.map(&:name).join(",")
  end
end
 