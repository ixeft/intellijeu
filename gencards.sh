#!/bin/bash
export GEM_HOME=$(pwd)/.gem
version=v1.0.1

if ! command -v bundle &>/dev/null; then
  echo "Please install bundle in order to run this script"
  exit
fi

if ! command -v pdftk &>/dev/null; then
  echo "Please install pdftk in order to run this script"
  exit
fi

bundle install --verbose
bundle exec ruby deck.rb
bundle exec ruby deck.rb mono

pdftk A=_output/intellijeu_front_deck_monochrome.pdf B=_output/intellijeu_front_rules_monochrome.pdf cat A B output _output/intellijeu_front_full_monochrome.pdf

pdftk A=_output/intellijeu_back_deck_monochrome.pdf B=_output/intellijeu_back_rules_monochrome.pdf cat A B output _output/intellijeu_back_full_monochrome.pdf

pdftk A=_output/intellijeu_front_deck_color.pdf B=_output/intellijeu_front_rules_color.pdf cat A B output _output/intellijeu_front_full_color.pdf

pdftk A=_output/intellijeu_back_deck_color.pdf B=_output/intellijeu_back_rules_color.pdf cat A B output _output/intellijeu_back_full_color.pdf

pdftk A=_output/intellijeu_front_full_monochrome.pdf B=_output/intellijeu_back_full_monochrome.pdf shuffle A B output dist/intellijeu_monochrome_recto_verso_${version}.pdf

pdftk A=_output/intellijeu_front_full_color.pdf B=_output/intellijeu_back_full_color.pdf shuffle A B output dist/intellijeu_couleur_recto_verso_${version}.pdf

pdftk A=_output/intellijeu_front_full_monochrome.pdf B=_output/intellijeu_back_full_monochrome.pdf cat A B output dist/intellijeu_monochrome_recto_puis_verso_${version}.pdf

pdftk A=_output/intellijeu_front_full_color.pdf B=_output/intellijeu_back_full_color.pdf cat A B output dist/intellijeu_couleur_recto_puis_verso_${version}.pdf

rm _output/*.pdf
