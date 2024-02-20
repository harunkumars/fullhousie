class LotteriesController < ApplicationController
  def update
    @lottery = Lottery.find(params[:id])
    @lottery.numbers.push(@lottery.game.next_number)
    @lottery.save!

    respond_to do |format|
      format.html         { redirect_to request.referer }
      format.turbo_stream { render turbo_stream: 'update' }
    end
  end
end
