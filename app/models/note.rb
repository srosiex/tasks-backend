class Note < ApplicationRecord
    belongs_to :task, dependent: :destroy
    # belongs_to :user
end
