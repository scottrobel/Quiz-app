class User < ApplicationRecord
  enum user_type: [:regular_user, :admin_user]
  has_many :quizzes, foreign_key: 'creator_id'
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
        :rememberable, :validatable
end
