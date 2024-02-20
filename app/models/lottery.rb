class Lottery < ApplicationRecord
  include ActionView::RecordIdentifier
  belongs_to :game
  # broadcasts_to ->(lottery) { :lottery_list }
  # after_create_commit do
  #   # broadcast_append_to('lottery_list', target: 'lotteries', partial: "lotteries/lottery", locals: { lottery: self })
  # end

  after_update_commit do
    broadcast_update_to('lottery_list', target: self, partial: "lotteries/lottery", locals: { lottery: self })
    broadcast_update_to('lottery_last_num', target: "#{dom_id(self)}_num", partial: "lotteries/lottery_num", locals: { lottery: self })
  end
end
