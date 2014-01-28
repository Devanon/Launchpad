# Launchpad: a music application ispired by Novation Launchpad
# Copyright (C) 2014 Pedro Javier RoRo
#
# This file is licensed under the terms of the GNU General Public License
# version 2. This program is licensed "as is" without any warranty of any
# kind, whether express or implied.
#

require 'gosu'


module ZOrder
  Background = 0
  UI = 1
  Button = 2
  Message = 3
end


module GuiWidgets

  class SquareButton

    def initialize(window, x, y, pressed=false)
      @window = window
      @x = x
      @y = y
      @pressed = [true, false].include?(pressed) ? pressed : false

      load_assets
    end

    def load_assets
      @@normal ||= Gosu::Image.new(@window, 'assets/gui/square_button.png')
      @@pressed ||= Gosu::Image.new(@window, 'assets/gui/square_button_pressed.png')
    end

    def change_state(pressed=nil)
      @pressed = pressed != nil ? pressed : !@pressed
    end

    def draw
      if @pressed
        @@pressed.draw(@x, @y, ZOrder::UI)
      else
        @@normal.draw(@x, @y, ZOrder::UI)
      end
    end

  end

  class Slider

    def initialize(window, x, y, value=0.5)
      @window = window
      @x = x
      @y = y
      @value = (0..1).include?(value) ? value : 0.5

      load_assets
    end

    def load_assets
      @@button ||= Gosu::Image.new(@window, 'assets/gui/slider_button.png')
      @@background ||= Gosu::Image.new(@window, 'assets/gui/slider_background.png')      
    end

    def increase(value=0.1)
      @value += value
      @value = 1 if @value > 1
    end

    def decrease(value=0.1)
      @value -= value
      @value = 0 if @value < 0
    end

    def change_state(value)
      @value = value if (0..1).include?(value)
    end      

    def draw
      @@background.draw(@x + 9, @y + 6, ZOrder::UI)
      @@button.draw(@x, @y + 120 - (@value * 120), ZOrder::UI)
    end

  end

  class RadioButton

    def initialize(window, x, y, value=false)
      @window = window
      @x = x
      @y = y
      @value = [true, false].include?(value) ? value : false

      load_assets
    end

    def load_assets
      @@on ||= Gosu::Image.new(@window, 'assets/gui/radio_button_on.png')
      @@off ||= Gosu::Image.new(@window, 'assets/gui/radio_button_off.png')
    end

    def change_state(value=nil)
      @value = value != nil ? value : !@value
    end

    def draw
      if @value
        @@on.draw(@x, @y, ZOrder::UI)
      else
        @@off.draw(@x, @y, ZOrder::UI)
      end
    end

  end

end # Module
