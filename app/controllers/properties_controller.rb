# encoding: utf-8
# frozen_string_literal: true

class PropertiesController < ApplicationController
  layout 'single_column'

  def new
  end

  def index
    @properties = Property.all.paginate(page: params[:page], per_page: 12)
    render layout: 'two_column_side_search'
  end

  private

end
