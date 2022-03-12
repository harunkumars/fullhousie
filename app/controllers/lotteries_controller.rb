class LotteriesController < ApplicationController
  def show
    @lottery = Lottery.find(params[:id])
  end

  def index
    @lotteries = Lottery.last(5)
  end

  def update
    @lottery = Lottery.find(params[:id])
    @lottery.numbers.push(@lottery.game.next_number)
    @lottery.save!

    respond_to do |format|
      format.turbo_stream { render turbo_stream: 'update' }
    end
  end
end
