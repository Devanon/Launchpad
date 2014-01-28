# Launchpad: a music application ispired by Novation Launchpad
# Copyright (C) 2014 Pedro Javier RoRo
#
# This file is licensed under the terms of the GNU General Public License
# version 2. This program is licensed "as is" without any warranty of any
# kind, whether express or implied.
#

require 'gosu'
require_relative 'gui'
require_relative 'samples_player'


class AppWindow < Gosu::Window

    @samples_data
    # { :sample_variable_id => {  :filename => String,
    #                             :play_mode => [play|cue|loop],
    #                             :channel => 1..8 } }
    
    @channels_data
    # 0: master 1-8: sliders
    # { channel_number[0..8] => { :volume => 0..1,
    #                             :instances_playing => [array of Gosu::SampleInstance] } }

  include SamplesPlayer

  def initialize
    super(800, 600, false)
    self.caption = "Launchpad"
    @debug = false
    @running = true
    @counter = 0

    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)
    @GUI = GUI.new(self)

    @samples_data = {}

    @channels_data = {}
    10.times do |i|
      @channels_data[i] = {}
      @channels_data[i][:volume] = 0.5
      @channels_data[i][:instances_playing] = []
    end
    
    @channels_selected = [1, 2, 3, 4, 5, 6, 7, 8] # All channels selected by default
    8.times do |i|
      radio_button = @GUI.instance_variable_get("@radio#{i+1}")
      radio_button.change_state
    end

    load_samples # samples_player.rb
  end
  
  def needs_cursor?
    true
  end

  def needs_redraw?
    @running
  end

  def update
    @counter += 1

    if @counter % 4 == 0 
      if button_down?(Gosu::KbUp)
        @channels_selected.each do |i|
          slider = @GUI.instance_variable_get("@slider#{i}")
          slider.increase
        end
        increase_volume(0.1, @channels_selected)
      elsif button_down? Gosu::KbDown
        @channels_selected.each do |i|
          slider = @GUI.instance_variable_get("@slider#{i}")
          slider.decrease
        end
        decrease_volume(0.1, @channels_selected)
      end
    end
  end
  
  def draw
    @GUI.draw
    debug_info if @debug
  end
  

  def button_down(id)
    case id
    when Gosu::KbF3 # Toggle debug info
      @debug = !@debug
      
    when Gosu::KbEscape
      close  # exit on press of escape key
    
    when Gosu::Kb0 # Deselect all channels
      @channels_selected.clear
      8.times do |i|
        radio = @GUI.instance_variable_get("@radio#{i+1}")
        radio.change_state(false)
      end

    when Gosu::Kb1..Gosu::Kb8 # Toggle channel selection
      char = button_id_to_char(id)
      toggle_channel(char.to_i) # samples_player.rb
      radio = @GUI.instance_variable_get("@radio#{char}")
      radio.change_state

    when Gosu::Kb9
      @channels_selected.clear.concat([1, 2, 3, 4, 5, 6, 7, 8])
      8.times do |i|
        radio = @GUI.instance_variable_get("@radio#{i+1}")
        radio.change_state(true)
      end  

    else # Pad buttons
      button_down_event("@sample_#{id}") # samples_player.rb
      button = @GUI.instance_variable_get("@button_#{id}")
      button.change_state(true) unless button.nil?
    end
  end

  def button_up(id)
    button_up_event("@sample_#{id}") # samples_player.rb
    button = @GUI.instance_variable_get("@button_#{id}")
    button.change_state(false) unless button.nil?
  end



  def debug_info
    @font.draw("Cnt:#{@counter} FPS:#{Gosu::fps}" , 0, 0, 1) if @debug
  end
  
end
