class UsersController < ApplicationController
  before_action :set_user,only:[:show,:edit ,:update]

  def new
    @user = User.new
  end

  def edit
    if current_user.id != set_user.id
      flash[:danger] = '権限がありません。'
      redirect_to tasks_path
    end
  end

  def show
    @tasks = @user.tasks
  end

  def create
    @user = User.new(user_params)
    @chk_user=User.where("name = ? AND email = ?" , @user.name , @user.email)
    # binding.pry
    # if @chk_user.id?
      if @user.save
        session[:user_id] = @user.id
        flash[:notice] = "アカウント作成後、ログインしました。"
        @tasks = current_user.tasks
        redirect_to user_path(@user.id)
      else
        render :new
      end
    # else
    #   flash[:notice] = "アカウントは既に作成に作成されています。"
    #   render :new
    # end

  end

  def update
    @user.current_admin = current_user.admin
    if @user.update(user_params)
      redirect_to user_path, notice: "ユーザー情報を変更しました。"
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email,:password, :password_confirmation, :admin)
  end

  def set_user
    @user = User.find(current_user.id)
  end
end
