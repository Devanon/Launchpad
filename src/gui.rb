# Launchpad: a music application ispired by Novation Launchpad
# Copyright (C) 2014 Pedro Javier RoRo
#
# This file is licensed under the terms of the GNU General Public License
# version 2. This program is licensed "as is" without any warranty of any
# kind, whether express or implied.
#

require 'gosu'
require_relative 'gui_widgets'

class GUI

  include GuiWidgets # gui_widgets.rb: Sliders, buttons, etc

  def initialize(window)
    @window = window
    @widgets = []

    load_assets
    inflate_gui
    create_attr_writers

  end

  def create_attr_writers
    instance_variables.each do |var|
        eval "def #{var.to_s.sub('@', '')}; #{var}; end"
    end
  end

  def load_assets
    @background = Gosu::Image.new(@window, 'assets/gui/background.png', false)
  end

  def inflate_gui
    @widgets << @button_16 = GUI::SquareButton.new(@window, 50, 25)
    @widgets << @button_17 = GUI::SquareButton.new(@window, 125, 25)
    @widgets << @button_18 = GUI::SquareButton.new(@window, 200, 25)
    @widgets << @button_19 = GUI::SquareButton.new(@window, 275, 25)

    @widgets << @button_22 = GUI::SquareButton.new(@window, 350, 25)
    @widgets << @button_23 = GUI::SquareButton.new(@window, 425, 25)
    @widgets << @button_24 = GUI::SquareButton.new(@window, 500, 25)
    @widgets << @button_25 = GUI::SquareButton.new(@window, 575, 25)
    
    @widgets << @button_30 = GUI::SquareButton.new(@window, 50, 100)
    @widgets << @button_31 = GUI::SquareButton.new(@window, 125, 100)
    @widgets << @button_32 = GUI::SquareButton.new(@window, 200, 100)
    @widgets << @button_33 = GUI::SquareButton.new(@window, 275, 100)

    @widgets << @button_36 = GUI::SquareButton.new(@window, 350, 100)
    @widgets << @button_37 = GUI::SquareButton.new(@window, 425, 100)
    @widgets << @button_38 = GUI::SquareButton.new(@window, 500, 100)
    @widgets << @button_39 = GUI::SquareButton.new(@window, 575, 100)
    
    @widgets << @button_44 = GUI::SquareButton.new(@window, 50, 175)
    @widgets << @button_45 = GUI::SquareButton.new(@window, 125, 175)
    @widgets << @button_46 = GUI::SquareButton.new(@window, 200, 175)
    @widgets << @button_47 = GUI::SquareButton.new(@window, 275, 175)

    @widgets << @button_50 = GUI::SquareButton.new(@window, 350, 175)
    @widgets << @button_51 = GUI::SquareButton.new(@window, 425, 175)
    @widgets << @button_52 = GUI::SquareButton.new(@window, 500, 175)
    @widgets << @button_53 = GUI::SquareButton.new(@window, 575, 175)

    @widgets << @button_fx_a = GUI::SquareButton.new(@window, 50, 250)
    @widgets << @button_fx_s = GUI::SquareButton.new(@window, 125, 250)
    @widgets << @button_fx_d = GUI::SquareButton.new(@window, 200, 250)
    @widgets << @button_fx_f = GUI::SquareButton.new(@window, 275, 250)

    @widgets << @button_fx_j = GUI::SquareButton.new(@window, 350, 250)
    @widgets << @button_fx_k = GUI::SquareButton.new(@window, 425, 250)
    @widgets << @button_fx_l = GUI::SquareButton.new(@window, 500, 250)
    @widgets << @button_fx_ñ = GUI::SquareButton.new(@window, 575, 250)

    @widgets << @button_fx_z = GUI::SquareButton.new(@window, 350, 325)
    @widgets << @button_fx_x = GUI::SquareButton.new(@window, 425, 325)
    @widgets << @button_fx_c = GUI::SquareButton.new(@window, 500, 325)
    @widgets << @button_fx_v = GUI::SquareButton.new(@window, 575, 325)

    @widgets << @button_fx_m = GUI::SquareButton.new(@window, 50, 325)
    @widgets << @button_fx_comma = GUI::SquareButton.new(@window, 125, 325)
    @widgets << @button_fx_period = GUI::SquareButton.new(@window, 200, 325)
    @widgets << @button_fx_slash = GUI::SquareButton.new(@window, 275, 325)

    @widgets << @slider1 = GUI::Slider.new(@window, 65, 405)
    @widgets << @slider2 = GUI::Slider.new(@window, 140, 405)
    @widgets << @slider3 = GUI::Slider.new(@window, 215, 405)
    @widgets << @slider4 = GUI::Slider.new(@window, 290, 405)
    @widgets << @slider5 = GUI::Slider.new(@window, 365, 405)
    @widgets << @slider6 = GUI::Slider.new(@window, 440, 405)
    @widgets << @slider7 = GUI::Slider.new(@window, 515, 405)
    @widgets << @slider8 = GUI::Slider.new(@window, 590, 405)
    
    @widgets << @radio1 = GUI::RadioButton.new(@window, 73, 555)
    @widgets << @radio2 = GUI::RadioButton.new(@window, 148, 555)
    @widgets << @radio3 = GUI::RadioButton.new(@window, 223, 555)
    @widgets << @radio4 = GUI::RadioButton.new(@window, 298, 555)
    @widgets << @radio5 = GUI::RadioButton.new(@window, 373, 555)
    @widgets << @radio6 = GUI::RadioButton.new(@window, 448, 555)
    @widgets << @radio7 = GUI::RadioButton.new(@window, 523, 555)
    @widgets << @radio8 = GUI::RadioButton.new(@window, 598, 555)

  end

  def add_widgets(type, x, y)
    @widgets << case type
    when :button
      GUI::SquareButton.new(@window, x, y)
    when :slider
      GUI::Slider.new(@window, x, y)
    end
  end

  def draw
    @background.draw(0, 0, ZOrder::Background)
    
    @widgets.each do |w|
      w.draw
    end
  end

end # Class
