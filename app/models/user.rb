class User < ApplicationRecord
  has_many :histories, dependent: :destroy
  attr :username
end
