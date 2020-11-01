module SessionsHelper
  
  # 引数に渡された値で、ログインを行う。
  def log_in(user)
    session[:user_id] = user.id
  end
  
  # 永続的セッションを記憶する。(Userモデルを参照)
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  # 永続的セッションを破棄する。
  def forget(user)
    user.forget # Userモデルを参照
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  # セッションと@current_userを破棄させる。
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
  
  # 現在ログイン中のユーザーがいる場合、オブジェクトを返します。
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  
  # 渡されたユーザーがログイン済みのユーザーであればtrueを返す
  def current_user?(user)
    user == current_user
  end
  
  # 現在ログイン中のユーザーがいればtrueが、違えばfalseが返ってくる
  def logged_in?
    !current_user.nil?
  end
  
  # 記憶しているURLに（またはデフォルトのURLへ）リダイレクトする
  def redirect_back_or(default_url)
    redirect_to(session[:forwarding_url] || default_url)
    session.delete(:forwarding_url)
  end
  
  # アクセスしようとしたurlを記憶する。
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
