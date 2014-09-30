class CatRentalRequest < ActiveRecord::Base
  STATUS_CHOICES = %w{PENDING APPROVED DENIED}

  validates :start_date, :end_date, :cat_id, presence: true
  # validates :status, inclusion: {
 #    in: STATUS_CHOICES,
 #    message: "invalid status!"
 #  }
  validate :approved_requests_do_not_overlap



  belongs_to :cat


  after_initialize do
    self.status ||= "PENDING"
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

<<-SQL
SELECT
first_rental_request.*
FROM
  cat_rental_requests AS first_rental_request
INNER JOIN
  cat_rental_requests AS second_rental_request
ON first_rental_request.cat_id = second_rental_request.cat_id
WHERE
  (first_rental_request.id <> second_rental_request.id) AND
  (first_rental_request.start_date BETWEEN
    second_rental_request.start_date AND
    second_rental_request.end_date)
SQL
