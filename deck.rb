require 'squib'
require 'game_icons'

type_icons_name = {
  "Competence"=> "brain",
  "Materiel"=> "swiss-army-knife",
  "Risque"=> "hazard-sign",
  "Mecanique"=> "gears",
  "Terrain"=> "hill-conquest"
}
type_icons_color = {
  "Competence"=>"#e1f5fe",
  "Materiel"=>"fff3e0",
  "Risque"=>"#ffebee",
  "Mecanique"=>"#e8f5e9",
  "Terrain"=>"#f5f5f5"
}


deck = Squib.xlsx file: 'intellijeu.xlsx'
colored = true
icone_fg_color = colored ? "#FFFFFF" : "#AAAAAA"
type_icon_mono_fg_color = "#555555" 
Squib::Deck.new(cards: deck['Titre'].size, width: '59mm', height: '92mm', layout: 'layout.yml') do
  #background color: '#230602'


  icones = deck['Icone'].map { |x|  GameIcons.get(x).recolor(bg_opacity: 0, fg: icone_fg_color ).string}
  frames = colored ? deck['Type'].map {|x| "Frame#{x}"} : "FrameBlackAndWhite"
  #types = deck['Type'].map {|x| "Type#{x}"}

  rect layout: :outerframe
  rect layout: frames
  #cut_zone radius: 25,  stroke_color: :white
  #safe_zone radius: 0, stroke_color: :red, margin: '3mm'
  rect layout: :DescRectShadow
  rect layout: :DescRect

  %w(Titre Description Exemple).each do |key|
    #rect layout: key
    text str: deck[key], layout: key
  end

  # Types
  print(type_icons_name[:Mecanique])
  type_icons = type_icons_name.map {|type,icon|
    [type, GameIcons.get(icon).recolor(bg_opacity: 0, fg: colored ? type_icons_color[type] : type_icon_mono_fg_color).string] }.to_h

  type_icons_cards = deck['Type'].map {|x| type_icons[x] }

  svg layout: "Type", data: type_icons_cards

  #niveau = deck['Niveau'].map {|x| "Niveau#{x}"}
  #svg layout: niveau


  svg data: icones, layout: :Icone

  #save format: :png, prefix: deck['Titre']
  save_pdf file: colored ? "intellijeu_front_color.pdf" : "intellijeu_front_monochrome.pdf", sprue: 'a4_euro_card.yml'
end

Squib::Deck.new(cards: deck['Titre'].size, width: '59mm', height: '92mm', layout: 'layout.yml') do
  rect layout: :outerframe
  rect layout: colored ? :FrameBack : :FrameBackBlackAndWhite

  svg data: GameIcons.get("shatter").recolor(bg_opacity: 0, fg: "#FFFFFF" ).string, layout: :IconeBack
  text str: "IntelliJeu", layout: :TitreBack

  save_pdf file: colored ? "intellijeu_back_color.pdf" : "intellijeu_back_monochrome.pdf", sprue: 'a4_euro_card.yml'
end
