class CatRentalRequest < ApplicationRecord
  STATUSES = %w(PENDING APPROVED DENIED)

  validates :cat_id, :start_date, :end_date, presence: true
  validates :status, inclusion: { in: STATUSES }
  validate :does_not_overlap_approved_request

  belongs_to :cat,
  primary_key: :id,
  foreign_key: :cat_id,
  class_name: "Cat"

  def overlapping_requests
    query = CatRentalRequest.where(cat_id: self.cat_id)
    query = query.where.not(id: self.id)
    query.where("((start_date <= ? AND ? <= end_date) OR (end_date >= ? AND ? >= start_date))", self.start_date, self.start_date, self.end_date, self.end_date)
  end

  def overlapping_approved_requests
    overlapping_requests.where(status: 'APPROVED')
  end

  def does_not_overlap_approved_request
    if overlapping_approved_requests.exists?
      errors[:cat_id] << "dates overlap with an approved request"
    end
  end

  def approve!
    CatRentalRequest.transaction do
      overlapping_requests.each do |request|
        request.deny!
      end
      self.status = 'APPROVED'
      self.save

    end
  end

  def deny!
    self.status = 'DENIED'
    self.save
  end
end
