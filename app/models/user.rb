class User < ApplicationRecord
  validates :name,  presence: true, length: { maximum: 30 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  before_validation { email.downcase! }
  has_secure_password
  validates :password, presence: true, length: { minimum: 8 }
  has_many :tasks, dependent: :destroy
  before_destroy :ensure_admin_deatroy
  before_update :ensure_admin_update
  # attr_accessor :current_admin

  def ensure_admin_deatroy
    throw(:abort) if User.where(admin: true).count == 1 && self.admin == true
  end

  def ensure_admin_update
     #binding.pry
     #アドミンユーザーを取得
    @admin_user = User.where(admin: true)
    #(adminのカウントが１かつ　adminの配列の一人目がいない) && adminの値が入っていない　
    if (@admin_user.count == 1 && @admin_user.first == self) && !(self.admin)
      errors.add(:admin,"は、最低でも１人は必要です。")
      throw(:abort)

    end
 
  end

end
