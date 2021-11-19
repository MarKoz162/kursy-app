class CourseTag < ApplicationRecord
 belongs_to :tag, counter_cache: true
 belongs_to :course
  
end  
  