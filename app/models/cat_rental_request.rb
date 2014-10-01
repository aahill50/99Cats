class CatRentalRequest < ActiveRecord::Base
  STATUS_CHOICES = %w{PENDING APPROVED DENIED}

  validates :start_date, :end_date, :cat_id, :user_id, presence: true
  validate :approved_requests_do_not_overlap

  belongs_to :cat

  belongs_to(
    :requester,
    class_name: "User",
    foreign_key: :user_id,
    primary_key: :id
  )


  after_initialize do
    self.status ||= "PENDING"
  end

  def approve!
    self.status = "APPROVED"
    self.save!
  end

  def deny!
    self.status = "DENIED"
    self.save
  end

  def pending?
    self.status == "PENDING"
  end


  def overlapping_pending_requests
    overlapping_requests.where("second_rental_request.status = 'PENDING'")
  end

private
  def overlapping_requests
    where_condition_1 = "('#{self.start_date}' BETWEEN
         second_rental_request.start_date AND
         second_rental_request.end_date)"
    where_condition_2 = "('#{self.end_date}' BETWEEN
         second_rental_request.start_date AND
         second_rental_request.end_date)"
    where_condition_3 = "('#{self.start_date}' <=
         second_rental_request.start_date AND '#{self.end_date}' >=
         second_rental_request.end_date)"

    CatRentalRequest
      .select("DISTINCT second_rental_request.*")
      .joins("INNER JOIN
         cat_rental_requests AS second_rental_request
         ON second_rental_request.cat_id = #{self.cat_id} ")
       .where("#{where_condition_1} OR #{where_condition_2} OR #{where_condition_3}")
  end

  def overlapping_approved_requests
    overlapping_requests.where("second_rental_request.status = 'APPROVED'")
  end


  def approved_requests_do_not_overlap
    if self.status == "APPROVED"
      unless overlapping_approved_requests.empty?
        errors[:overlap] << "date range overlaps existing approved requests"
      end
    end
  end

end
