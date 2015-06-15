require 'rails_helper'

RSpec.describe Player, type: :model do
  it "can load a player" do
    player = ["571448, Nolan Arenado "]
    expect(Player.count).to eq 0
    Player.load_players player, "col"
    expect(Player.count).to eq 1
    nolan = Player.first
    expect(nolan.first_name).to eq "nolan"
  end

  it 'can scrape a position' do
    player =Player.create(mlb_id: 571448, first_name: 'nolan', last_name:'arendado')
    player.get_position
    expect(player.position).to eq "3B"
  end

  it "can search for a player by name" do
    player =Player.create(mlb_id: 571448, first_name: 'nolan', last_name:'arendado')
    options ={last_name: "arenado", first_name: 'nolan'}
    results =Player.search options
    expect(results[0].id).to eq player.id
  end

  it "can search for a player by name and team" do
    player =Player.create(mlb_id: 571448, first_name: 'nolan', last_name:'arendado', team:'col')
    options ={last_name: "arenado", first_name: 'nolan', team: 'col'}
    results =Player.search options
    expect(results[0].id).to eq player.id
  end


end
