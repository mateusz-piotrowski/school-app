# == Schema Information
#
# Table name: enrollments
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  course_id  :integer          not null
#  student_id :integer          not null
#
# Indexes
#
#  index_enrollments_on_course_id                 (course_id)
#  index_enrollments_on_student_id                (student_id)
#  index_enrollments_on_student_id_and_course_id  (student_id,course_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (course_id => courses.id)
#  fk_rails_...  (student_id => users.id)
#

require 'rails_helper'

RSpec.describe Enrollment do
  subject(:enrollment) { build :enrollment }

  describe 'validations' do
    it { should belong_to(:student).class_name('User') }

    it { should belong_to(:course) }

    it { is_expected.to validate_uniqueness_of(:student_id).scoped_to(:course_id) }

    it { should have_many(:solutions).dependent(:destroy) }
  end
end
