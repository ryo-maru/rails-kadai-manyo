class Task < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true
  validates :deadline, presence: true
  validates :status, presence: true
  validates :priority, presence: true

  enum status: { 未着手: 0, 着手中: 1, 完了: 2 }
  enum priority: { 低: 0, 中: 1, 高: 2 }
  
  scope :search_by_task_title, -> (search){where('title like ?', "%#{search}%" )}
  scope :search_by_status, -> status { where(status: status) }
  scope :search_tag, -> (data){ joins(:tags).where('tags.id = ?', data)}


  max_paginates_per 5
  belongs_to :user
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
end
