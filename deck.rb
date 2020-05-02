require 'squib'
require 'game_icons'

card_type = []


Squib::Deck.new(cards: 78,layout: 'layout.yml') do
  #background color: '#230602'
  deck = xlsx file: 'mecaniscout.xlsx'
  icones = deck['Icone'].map { |x|  GameIcons.get(x).recolor(bg_opacity: 0, fg: 'FFFFFF' ).string} 
  frames = deck['Type'].map {|x| "Frame#{x}"}
  types = deck['Type'].map {|x| "Type#{x}"}

  cut_zone radius: 25,  stroke_color: :white
  safe_zone radius: 0, stroke_color: :red
  rect layout: frames
  rect layout: :DescRectShadow
  rect layout: :DescRect

  %w(Titre Description Exemple).each do |key|
    #rect layout: key
    text str: deck[key], layout: key
  end

  svg layout: types 

  niveau = deck['Niveau'].map {|x| "Niveau#{x}"}
  svg layout: niveau


  svg data: icones, layout: :Icone

  save format: :pdf
end
