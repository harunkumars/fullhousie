class GamesController < ApplicationController
  before_action :game_params, only: :create
  def new
    @game = Game.new
  end

  def create
    Game.create(game_params || Time.now)
    redirect_to action: :index
  end

  def show
    @game = Game.find(params[:id])
  end

  def index
    @games = Game.last(10)
  end

  def update
    @game = Game.find(params[:id])
    @game.end
    redirect_to action: :show
  end

  private

  def game_params
    params.require(:game).permit(:name)
  end
end
