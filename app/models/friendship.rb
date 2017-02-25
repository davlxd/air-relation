class Friendship < ApplicationRecord
  enum status: {pending: 'PENDING', accepted: 'ACCEPTED'}
end
