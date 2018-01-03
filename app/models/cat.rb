class Cat < ApplicationRecord
  COLORS = %w(Black White Gray Orange Red Purple Green Blue Yellow Brown Invisible)

  validates :birthdate, :color, :name, :sex, :description, presence: true
  validates :color, inclusion: { in: COLORS }

  has_many :rental_requests,
  primary_key: :id,
  foreign_key: :cat_id,
  class_name: "CatRentalRequest",
  dependent: :destroy

  
end
