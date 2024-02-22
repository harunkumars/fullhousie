ActiveAdmin.register Game do
  actions :all, except: [:edit]
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :name, :no_of_players, players_attributes: [:id, :name, :_destroy]
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :status, :last_number, :numbers]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  form do |f|
    f.inputs 'Game Details' do
      f.input :name

      f.inputs 'Players' do
        f.has_many :players,
                  heading: false,
                  new_record: 'Add Player',
                  remove_record: 'Remove Player',
                  allow_destroy: -> (c) { c.author?(current_admin_user) } do |b|
          b.input :name
        end
      end
    end

    f.actions
  end

  show do
    render 'show', { game: game }
  end

  controller do
    def create
      @players_attributes = game_params[:players_attributes]
      @game = Game.create!(name: game_params[:name])

      assign_players if @players_attributes
      @game.start

      redirect_to admin_game_path @game
    end

    def update
      @game = Game.find(params[:id])
      @game.end
      redirect_to action: :show
    end

    private

    def game_params
      params.require(:game).permit(:name, players_attributes: [:id, :name, :_destroy])
    end

    def assign_players
      @players_attributes.each do |key, player_attributes|
        player_name = player_attributes[:name].empty? ? "Player_#{key.to_i + 1}" : player_attributes[:name]
        @game.players.create!(name: player_name)
      end
    end
  end
end
