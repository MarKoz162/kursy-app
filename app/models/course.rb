class Course < ApplicationRecord
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user}
  validates :title, :short_description, :language, :price, :level, presence: true
  validates :description, presence: true, length: { minimum: 5, maximum: 3000}
  validates :short_description, presence: true, length: { minimum: 5}
  validates :title, uniqueness: true,length: { maximum: 70 }
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  
  belongs_to :user, counter_cache: true
  has_many :lessons, dependent: :destroy
  has_many :enrollments, dependent: :restrict_with_error
  has_many :user_lessons, through: :lessons
  has_many :course_tags, dependent: :destroy
  has_many :tags, through: :course_tags
   
  has_one_attached :avatar
  validates :avatar, presence: true, on: :update
  validates :avatar,content_type: ['image/png', 'image/jpg', 'image/jpeg'],size: { less_than: 500.kilobytes , message: 'size shoul be under 500 kilobytes' }
  
  
  def to_s
      title
  end
  
  scope :latest, -> {  limit(3).order(created_at: :desc) }
  scope :top_rated, -> { limit(3).order(average_rating: :desc, created_at: :desc) }
  scope :popular, -> { limit(3).order(enrollments_count: :desc, created_at: :desc) }
  scope :purchased, -> { limit(3).joins(:enrollments).where(enrollments: {user: current_user}).order(created_at: :desc) }
  scope :published, -> { where(published: true)}
  scope :unpublished, -> { where(published: false)}
  scope :approved, -> { where(approved: true)}
  scope :unapproved, -> { where(approved: false)}
  
  def calculate_income
    update_column :income, (enrollments.map(&:price).sum)
    user.calculate_course_income
  end
  
  
  
  has_rich_text :description
  
  extend FriendlyId
  friendly_id :title, use: :slugged
  
  LANGUAGES = [:"English",:"Russian",:"German"]
  def self.languages
    LANGUAGES.map {|language| [ language , language ] }
  end
  
  LEVELS = [:"Beginner",:"Intermidate",:"Advanced"]
  def self.levels
    LEVELS.map {|level| [ level , level ] }
  end
  
  def progress(user)
    unless self.lessons_count == 0
      user_lessons.where(user: user).count/self.lessons_count.to_f*100
    end  
  end
  def bought(user)
    self.enrollments.where(user_id: [user.id], course_id: [self.id]).empty?
  end
  
  def update_rating
    if enrollments.any? && enrollments.where.not(rating: nil).any?
      update_column :average_rating, (enrollments.average(:rating).round(2).to_f)
    else
      update_column :average_rating, (0.0)
    end  
  end  
end
