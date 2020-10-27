module SessionsHelper
  
  # 引数に渡された値で、ログインを行う。
  def log_in(user)
    session[:user_id] = user.id
  end
  
  # セッションと@current_userを破棄させる。
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
  
  # 現在ログイン中のユーザーがいる場合、オブジェクトを返します。
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end
  
  # 現在ログイン中のユーザーがいればtrueが、違えばfalseが返ってくる
  def logged_in?
    !current_user.nil?
  end
end