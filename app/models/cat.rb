class Cat < ActiveRecord::Base
  COLOR_CHOICES = ["black", "white", "brown", "striped", "spotted"]
  SEX_CHOICES = ["M", "F"]

  validates :name, :birth_date, presence: true

  validates :color, presence: true, inclusion: {
    in: COLOR_CHOICES,
    message: "%{value} is not a valid color"
  }

  validate :birth_date_is_not_in_the_future

  validates :sex, presence: true, inclusion: {
    in: SEX_CHOICES,
    message: "%{value} is not a valid gender"
  }

  validates :user_id, presence: true

  belongs_to(
    :owner,
    class_name: "User",
    foreign_key: :user_id,
    primary_key: :id
  )

  has_many(
    :cat_rental_requests,
    :dependent => :destroy,
    order: "start_date ASC, end_date ASC"
    )

 has_many :requesters, through: :cat_rental_requests, source: :requester

  def age
    # age is in years
    ((Date.today - birth_date).to_f / 365).to_i
  end


  private
  def birth_date_is_not_in_the_future
    if birth_date && birth_date > Date.today
      errors[:birth_date] << "Cat can't be from the future!!!"
    end
  end

end
