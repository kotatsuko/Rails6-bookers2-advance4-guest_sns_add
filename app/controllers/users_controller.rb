class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:edit,:update]
  before_action :authenticate_user!, only: [:following, :followers]
  before_action :ensure_guest_user,only:[:edit]


  def show
    @user = User.find(params[:id])
    @currentUserEntry = Entry.where(user_id:current_user.id)
    @userEntry = Entry.where(user_id:@user.id)
    unless @user.id == current_user.id
      @currentUserEntry.each do |currentuser|
        @userEntry.each do |user|
          if currentuser.room_id == user.room_id then
            @isRoom = true
            @roomId = currentuser.room_id
          end
        end
      end
      unless @isRoom
        @room = Room.new
        @entry = Entry.new
      end
    end

    @books = @user.books
    @book = Book.new
  end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
    @user=User.find(params[:id])
    unless @user==current_user
      redirect_to user_path(current_user)
    end
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render "edit"
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end

  def ensure_guest_user
    @user=User.find(params[:id])
    if @user.name=="guestuser"
      redirect_to user_path(current_user),notice:"ゲストユーザーはプロフィール編集画面に遷移できません。"
    end
  end




end
