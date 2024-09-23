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
rules = Squib.xlsx file: 'rules.xlsx'
colored = true
if ARGV.length > 0 and ARGV[0].start_with?("mono")
  colored = false
  puts "Back and white cards"
end

icone_fg_color = colored ? "#FFFFFF" : "#AAAAAA"
type_icon_mono_fg_color = "#555555" 

# Generer les cartes coté recto
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
  save_pdf file: colored ? "intellijeu_front_deck_color.pdf" : "intellijeu_front_deck_monochrome.pdf", sprue: 'a4_euro_card.yml'
end

# Générer les règles
Squib::Deck.new(cards: rules['Title'].size, width: '59mm', height: '92mm', layout: 'layout.yml') do
  rect layout: :outerframe
  #rect layout: colored ? :frame : :FrameBlackAndWhite
  rect layout: :frame

  #svg data: GameIcons.get("shatter").recolor(bg_opacity: 0, fg: "#FFFFFF" ).string, layout: :IconeBack
  
  rules['Content'].each { |str| str.gsub! /%n/, "\n" }
  %w(Title Content).each do |key|
    #rect layout: key
    text str: rules[key], layout: key + "Rule"
  end

  save_pdf file: colored ? "intellijeu_front_rules_color.pdf" : "intellijeu_front_rules_monochrome.pdf", sprue: 'a4_euro_card.yml'
end

# Generer les cartes coté verso
Squib::Deck.new(cards: deck['Titre'].size, width: '59mm', height: '92mm', layout: 'layout.yml') do
  rect layout: :outerframe
  rect layout: colored ? :FrameBack : :FrameBackBlackAndWhite

  svg data: GameIcons.get("shatter").recolor(bg_opacity: 0, fg: "#FFFFFF" ).string, layout: :IconeBack
  text str: "IntelliJeu", layout: :TitreBack

  save_pdf file: colored ? "intellijeu_back_deck_color.pdf" : "intellijeu_back_deck_monochrome.pdf", sprue: 'a4_euro_card.yml'
end

# Generer les cartes règles verso
Squib::Deck.new(cards: rules['Title'].size, width: '59mm', height: '92mm', layout: 'layout.yml') do
  rect layout: :outerframe
  rect layout: colored ? :FrameBackRules : :FrameBackRulesBlackAndWhite

  svg data: GameIcons.get("shatter").recolor(bg_opacity: 0, fg: "#FFFFFF" ).string, layout: :IconeBack
  text str: "Règle IntelliJeu", layout: :TitreBack

  save_pdf file: colored ? "intellijeu_back_rules_color.pdf" : "intellijeu_back_rules_monochrome.pdf", sprue: 'a4_euro_card.yml'
end
