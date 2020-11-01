class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  before_action :logged_in_user, only: [:index, :show, :edit, :update]
  before_action :correct_user, only: [:edit, :update]

  def index
    @users = User.paginate(page: params[:page])
  end
  
  def new
    @user = User.new
  end
  
  def show
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user # 保存成功後にログインします。
      flash[:success] = "新規作成に成功しました。"
      redirect_to @user
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to @user
    else
      render :edit
    end
  end
  

  private
    
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
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
end
