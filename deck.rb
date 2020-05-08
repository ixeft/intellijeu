require 'squib'
require 'game_icons'

card_type = []

deck = Squib.xlsx file: 'mecaniscout.xlsx'

Squib::Deck.new(cards: deck['Titre'].size, width: '59mm', height: '92mm', layout: 'layout.yml') do
  #background color: '#230602'
  icones = deck['Icone'].map { |x|  GameIcons.get(x).recolor(bg_opacity: 0, fg: 'FFFFFF' ).string} 
  frames = deck['Type'].map {|x| "Frame#{x}"}
  types = deck['Type'].map {|x| "Type#{x}"}

  rect layout: :outerframe
  rect layout: frames
  #cut_zone radius: 25,  stroke_color: :white
  safe_zone radius: 0, stroke_color: :red, margin: '3mm'
  rect layout: :DescRectShadow
  rect layout: :DescRect

  %w(Titre Description Exemple).each do |key|
    rect layout: key
    text str: deck[key], layout: key
  end

  svg layout: types 

  niveau = deck['Niveau'].map {|x| "Niveau#{x}"}
  svg layout: niveau


  svg data: icones, layout: :Icone
  
  save_pdf sprue: 'a4_euro_card.yml'
end
