class GamesController < ApplicationController
  def show
    @game = Game.find(params[:id])
  end

  def update
    @game = Game.find(params[:id])
    @game.end
    redirect_to action: :show
  end
end
