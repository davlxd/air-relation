class User < ApplicationRecord
  enum status: {live: 'LIVE', blocked: 'BLOCKED'}
end
