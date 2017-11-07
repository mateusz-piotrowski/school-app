require 'rails_helper'

RSpec.describe CoursePolicy do
  subject { described_class.new(user, course) }

  let(:course) { create :course }
  let(:teacher) { course.teacher }

  context 'being a visitor' do
    let(:user) { nil }

    it { is_expected.to permit_actions(%i[index show]) }
    it { is_expected.to forbid_actions(%i[create update destroy list_lectures list_students list_tasks enroll]) }
  end

  context 'being a user' do
    let(:user) { build_stubbed :user }

    it { is_expected.to permit_actions(%i[index show enroll]) }
    it { is_expected.to forbid_actions(%i[create update destroy list_lectures list_students list_tasks]) }
  end

  context 'being the course student' do
    let(:user) { u = create :user; u.enroll_in(course); u }

    it { is_expected.to permit_actions(%i[index show list_lectures list_tasks]) }
    it { is_expected.to forbid_actions(%i[create update destroy list_students enroll]) }
  end

  context 'being a teacher' do
    let(:user) { build_stubbed :teacher }

    it { is_expected.to permit_actions(%i[index show create enroll]) }
    it { is_expected.to forbid_actions(%i[update destroy list_lectures list_students list_tasks]) }
  end

  context 'being the course teacher' do
    let(:user) { course.teacher }

    it { is_expected.to permit_actions(%i[index show create update destroy list_lectures list_students list_tasks]) }
    it { is_expected.to forbid_action(:enroll) }
  end
end
