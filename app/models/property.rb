# encoding: utf-8
# frozen_string_literal: true

class Property < BizmatchController

  def new
    @residential_property = BuyResidentialProperty.new
  end

end
