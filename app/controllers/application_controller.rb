class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  
  $days_of_the_week = %w{日 月 火 水 木 金 土}
  
  # before_action関係
  def set_user
    @user = User.find(params[:id])
  end
  
  # ログイン済みのユーザーなのかを確認する。
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "ログインしてください。"
      redirect_to login_url
    end
  end
  
  # 現在ログインしているユーザーがアクセスしてきたユーザーと一致しているのか？
  def correct_user
    redirect_to(root_url) unless current_user?(@user) # current_user?はセッションヘルパーに定義
  end
  
  # システム管理者なのかを判定する
  def admin_user
    redirect_to root_url unless current_user.admin?
  end
  
  # ページ出力前に１か月分のデータを確認、セットします。
  def set_one_month
    @first_day = params[:date].nil? ?
    Date.current.beginning_of_month : params[:date].to_date #三項演算子
    @last_day = @first_day.end_of_month
    one_month = [*@first_day..@last_day] # 対象の月の日数を代入します。
    # ユーザーに紐づく１か月分のレコードを検索し取得します。
    @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
    
  unless one_month.count == @attendances.count # 月の出勤日数と月の日数が一致するかを評価する。
    ActiveRecord::Base.transaction do
      one_month.each { |day| @user.attendances.create!(worked_on: day) }
    end
    @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
  end
  
  rescue ActiveRecord::RecordInvalid #　トランザクションによるエラーの分岐処理
    flash[:danger] = "ページ情報の取得に失敗しました、再アクセスしてください。"
    redirect_to root_url
  end
end
