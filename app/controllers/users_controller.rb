# encoding: utf-8
# frozen_string_literal: true

class UsersController < ApplicationController
  layout 'two_column_side_search'

  def new
    @user = User.new
    @user.build_role
    render layout: 'two_column_side_menu'
  end

  def create
    @user = User.new(params.require(:user).permit(:last_name, :first_name, :email, :role_id, :display_name))
    @user.company_id = current_user.company_id
    @user.skip_password_validation = true
    @user.parent_id = current_user.parent_id
    @user.individual_use = current_user.individual_use
    unless @user.valid?(:all)
      render :new, layout: 'two_column_side_menu'
      return
    end
    @user.save!
    flash[:success] = t('msg.create_sub_account')
    redirect_to manage_users_users_path
  end

  private

end
