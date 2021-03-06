class Lesson < ApplicationRecord
  belongs_to :course, counter_cache: true
  has_many :user_lessons, dependent: :destroy
  has_many :comments, dependent: :destroy
  
  
  validates :title, :content, :course, presence: true
  validates :title, uniqueness: true,length: { maximum: 70 }
  
  extend FriendlyId
  friendly_id :title, use: :slugged
  
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }
  
  include RankedModel
  ranks :row_order, with_same: :course_id
  
  def to_s
    title
  end
  
  def prev
    course.lessons.where("row_order < ?", row_order).order(:row_order).last
  end 
  
  def next
    course.lessons.where("row_order > ?", row_order).order(:row_order).first
  end 
  
  has_rich_text :content
  
  def viewed(user)
    self.user_lessons.where(user: user).present?
  end  
  
end
