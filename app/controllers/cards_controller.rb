class CardsController < ApplicationController
  # before_action :card_params
  def show
    @card = Card.find(params[:id])
  end

  # private
  # def card_params
  #   params.require(:card).permit(:id)
  # end
end
