class Attendance < ApplicationRecord
  belongs_to :user
  
  validates :worked_on, presence: true
  validates :note, length: { maximum: 50 }
  
  # 出勤時間が存在しない場合、退勤時間は無効になる
  validate :finished_at_is_invalid_without_a_started_at
  # 出勤時間と退勤時間が存在する時に出勤時間より、退勤時間が早い場合は無効
  validate :started_at_than_finished_at_fast_if_invalid
  # 出社もしくは退社のみの入力を無効にする
  # validate :started_at_and_finished_at_present
  
  def finished_at_is_invalid_without_a_started_at
    errors.add(:started_at, "が必要です") if started_at.blank? && finished_at.present?
  end
  
  # def started_at_and_finished_at_present
  #   errors.add("出社時間と退社時間は同時に入力しないといけません。")
  #   if started_at.present? && finished_at.blank?
  #   end
  # end
  
  def started_at_than_finished_at_fast_if_invalid
    if started_at.present? && finished_at.present?
      errors.add(:started_at, "より早い退勤時間は無効です") if started_at > finished_at
    end
  end
end
