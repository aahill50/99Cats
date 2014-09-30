class Cat < ActiveRecord::Base
  COLOR_CHOICES = ["black", "white", "brown", "striped", "spotted"]
  SEX_CHOICES = ["M", "F"]

  validates :color, presence: true, inclusion: {
    in: COLOR_CHOICES,
    message: "%{value} is not a valid color"
  }

  validate :birth_date_is_not_in_the_future

  validates :sex, presence: true, inclusion: {
    in: SEX_CHOICES,
    message: "%{value} is not a valid gender"
  }

  validates :name, presence: true


  def age
    # age is in years
    ((Date.today - birth_date).to_f / 365).to_i
  end


  private
  def birth_date_is_not_in_the_future
    if birth_date > Date.today
      errors[:birth_date] << "Cat can't be from the future!!!"
    end
  end

end
