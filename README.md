# Install

- install ruby bundler

install deps

```
bundle install
```

Install font
- Lobster
- Dosis

## Compile cardgame

```
bundle exec ruby deck.rb
```

Resulting card will be in 
> _output/


## Combine back and front

```
pdftk A=_output/intellijeu_front_monochrome.pdf B=_output/intellijeu_back_monochrome.pdf shuffle A B output _output/intellijeu_monochrome.pdf
```
