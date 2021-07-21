class Task < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true
  validates :deadline, presence: true
  validates :status, presence: true
  enum status: { 未着手: 0, 着手中: 1, 完了: 2 }
  scope :search_by_task_title, -> (search){where('title like ?', "%#{search}%" )}
  scope :search_by_status, -> status { where(status: status) }
  validates :priority, presence: true
  enum priority: { 低: 0, 中: 1, 高: 2 }
  max_paginates_per 5
  belongs_to :user
end
