# Launchpad: a music application ispired by Novation Launchpad
# Copyright (C) 2014 Pedro Javier RoRo
#
# This file is licensed under the terms of the GNU General Public License
# version 2. This program is licensed "as is" without any warranty of any
# kind, whether express or implied.
#

require 'gosu'


module SamplesPlayer

  # Add a sample as an instance variable to the app
  def add_sample(variable, file, play_mode=nil)
    instance_variable_set variable, Gosu::Sample.new(self, file) 
  end

  # Read the config file and assing samples to variables
  def load_samples(filename='samples.cfg')

    File.open(filename).each do |line|

      next if line =~ /^\s*#/ # Comment lines
      next if line =~ /^\s*$/   # Empty lines

      # RegEx =>     letter    filename         playmode           channel
      if line =~ /^\s*(.)\s*:\s*'(.*)'\s*:\s*(play|cue|loop)\s*:\s*([1-9])\s*$/
        
        # Get info from the regex capture groups
        letter = $1
        sample_file = $2
        play_mode = $3
        channel = $4

        variable_name = "@sample_#{char_to_button_id(letter.downcase)}"

        add_sample variable_name, sample_file
        var_id = variable_name.to_sym
        @samples_data[var_id] = {}
        @samples_data[var_id][:filename] = sample_file
        @samples_data[var_id][:play_mode] = play_mode
        @samples_data[var_id][:channel] = channel.to_i
      end

    end
  end


  # Play a loaded sample and keep track of the instance playing for control purpouses
  def play(sample_variable)
    sample = instance_variable_get sample_variable
    unless sample.nil?
    
      loop_mode = @samples_data[sample_variable.to_sym][:play_mode] != 'play'
      channel = @samples_data[sample_variable.to_sym][:channel]
      volume = @channels_data[channel][:volume]

      sample_instance = sample.play(volume, 1, loop_mode)
      instance_variable_set "#{sample_variable}_instance", sample_instance
      @channels_data[channel][:instances_playing] << sample_instance
    end
  end

  def stop(sample_variable)
    sample_instance = instance_variable_get "#{sample_variable}_instance"
    unless sample_instance.nil?
      sample_instance.stop
      channel = @samples_data[sample_variable.to_sym][:channel]
      @channels_data[channel][:instances_playing].delete(sample_instance)
      sample_instance = nil  
    end
  end

  def pause(sample_variable)
    sample_instance = instance_variable_get "#{sample_variable}_instance"
    sample_instance.pause unless sample_instance.nil?
  end

  def resume(sample_variable)
    sample_instance = instance_variable_get "#{sample_variable}_instance"
    sample_instance.resume unless sample_instance.nil?
  end

  def toggle_play(sample_variable)
    sample_instance = instance_variable_get "#{sample_variable}_instance"
    
    if sample_instance.nil?
      play(sample_variable) 
    else
      sample_instance.playing? ? stop(sample_variable) : play(sample_variable)
    end
  end

  def button_down_event(sample_variable)
    sample = instance_variable_get sample_variable
    return if sample.nil?

    sample_instance = instance_variable_get "#{sample_variable}_instance"
    play_mode = @samples_data[sample_variable.to_sym][:play_mode]

    case play_mode
    when 'play'
      if sample_instance && sample_instance.playing?
        stop(sample_variable)
      else
        play(sample_variable)
      end

    when 'cue'
      play(sample_variable)

    when 'loop'
      if sample_instance && sample_instance.playing?
        stop(sample_variable)
      else
        play(sample_variable)
      end
    end

    sample = sample_instance = play_mode = nil
  end

  def button_up_event(sample_variable)
    sample = instance_variable_get sample_variable
    return if sample.nil?

    sample_instance = instance_variable_get "#{sample_variable}_instance"
    play_mode = @samples_data[sample_variable.to_sym][:play_mode]

    return if sample.nil?

    case play_mode
    when 'cue'
      stop(sample_variable)
    end
    sample = sample_instance = play_mode = nil
  end


  # Toggle channel selection
  def toggle_channel(channel)
    if @channels_selected.include? channel
      @channels_selected.delete(channel)
    else
      @channels_selected << channel
    end
  end

  def increase_volume(value, channels)
    channels.each do |ch|
      vol = @channels_data[ch][:volume] + value;
      vol = 1 if vol > 1
      @channels_data[ch][:instances_playing].each do |instance|
        instance.volume = vol
      end
      @channels_data[ch][:volume] = vol
    end
  end

  def decrease_volume(value, channels)
    channels.each do |ch|
      vol = @channels_data[ch][:volume] - value;
      vol = 0 if vol < 0
      @channels_data[ch][:instances_playing].each do |instance|
        instance.volume = vol
      end
      @channels_data[ch][:volume] = vol
    end
  end

end
