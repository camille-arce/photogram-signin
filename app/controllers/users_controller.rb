class UsersController < ApplicationController

  def index
    @users = User.all.order({ :username => :asc })

    render({ :template => "users/index.html" })
  end

  def show
    the_username = params.fetch("the_username")
    @user = User.where({ :username => the_username }).at(0)

    render({ :template => "users/show.html.erb" })
  end

  def registration
    render({ :template => "users/sign_up_form.html.erb" })
  end

  def create
    user = User.new

    user.username = params.fetch("input_username")
    user.password = params.fetch("input_password")
    user.password_confirmation = params.fetch("input_password_confirmation")

    save_status = user.save

    if save_status = user.save
      # session is a hash, needs a key and a value
      session.store(:user_id, user.id)

      redirect_to("/users/#{user.username}", { :notice => "Welcome #{user.username}!" })
    else
      redirect_to("/user_sign_up", { :alert => user.errors.full_messages.to_sentence })
    end
  end

  def new_sign_in
    render({ :template => "users/sign_in.html.erb" })
  end

  def toast_cookies
    reset_session

    redirect_to("/", { :notice => "Goodbye!" })
  end

  def update
    the_id = params.fetch("the_user_id")
    user = User.where({ :id => the_id }).at(0)

    user.username = params.fetch("input_username")

    user.save

    redirect_to("/users/#{user.username}")
  end

  def authenticate

    # get the username from params
    username = params.fetch("input_username") # this is from sign_in.html.erb

    # get the password from params
    password = params.fetch("input_password") # this is from sign_in.html.erb

    # look up record from the db matching username
    user = User.where({ :username => username }).at(0)

    # if there's no record, redirect back to sign in
    if user == nil
      redirect_to("/user_sign_in", { :alert => "User does not exist." })
    else
      # if there's a record, check to see if password matches
      if user.authenticate(password)
        # if so, set the cookie, redirect to homepage
        session.store(:user_id, user.id)

        redirect_to("/", { :notice => "Welcome back #{user.username}!" })
      else
        # if not, redirect back to sign in form
        redirect_to("/user_sign_in", { :alert => "Password does not match" })
      end
    end
  end


  def destroy
    username = params.fetch("the_username")
    user = User.where({ :username => username }).at(0)

    user.destroy

    redirect_to("/users")
  end
end
