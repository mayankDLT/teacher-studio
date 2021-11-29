class Categoryexamuser < ActiveRecord::Base
  belongs_to :categoryexam
  belongs_to :categoryuser
  serialize   :question_set
  skip_time_zone_conversion_for_attributes << :exam_date
end
