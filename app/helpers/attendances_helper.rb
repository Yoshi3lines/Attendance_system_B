module AttendancesHelper
  def attendance_state(attendance)
    # 受けとったAttendanceオブジェクトが当日と一致するのかを判定する。
    if Date.current == attendance.worked_on
      return '出社' if attendance.started_at.nil?
      return '退社' if attendance.started_at.present? && attendance.finished_at.nil?
    end
    # どちらにも当てはまらない場合はfalseを返す。
    false
  end
  
  # 出社時間と退社時間を受け取り、在社時間を計算して返す。
  def working_times(start, finish)
    format("%.2f", ((finish - start) / 60) / 60.0)
  end
end
