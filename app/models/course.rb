class Course < ApplicationRecord
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user}
  validates :title, :short_description, :language, :price, :level, presence: true
  validates :description, presence: true
  
  belongs_to :user
  has_many :lessons, dependent: :destroy
  def to_s
      title
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
  
end
