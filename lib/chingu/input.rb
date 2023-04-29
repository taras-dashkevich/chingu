#--
#
# Chingu -- OpenGL accelerated 2D game framework for Ruby
# Copyright (C) 2009 ippa / ippa@rubylicio.us
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
#
#++

module Chingu
  module Input
    include Gosu
    
    #
    # Ruby symbols describing https://www.rubydoc.info/gems/gosu/Gosu
    #
    CONSTANT_TO_SYMBOL = {
      KB_0 => :zero,
      KB_1 => :one,
      KB_2 => :two,
      KB_3 => :three,
      KB_4 => :four,
      KB_5 => :five,
      KB_6 => :six,
      KB_7 => :seven,
      KB_8 => :eight,
      KB_9 => :nine,
    
      KB_BACKSPACE  => [:backspace],
      KB_DELETE     => [:delete, :del],
      KB_DOWN       => [:down_arrow, :down],
      KB_END        => [:end],
      KB_ENTER      => [:enter],
      KB_ESCAPE     => [:escape, :esc],

      KB_HOME          => [:home],
      KB_INSERT        => [:insert, :ins],
      KB_LEFT          => [:left_arrow, :left],
      KB_LEFT_ALT      => [:left_alt, :lalt],
      KB_LEFT_CONTROL  => [:left_control, :left_ctrl, :lctrl],
      KB_LEFT_SHIFT    => [:left_shift, :lshift],
      KB_LEFT_META     => [:left_meta, :lmeta],

      KB_COMMA             => [:",", :comma],
      KB_APOSTROPHE        => [:"'", :apostrophe],
      KB_BACKTICK          => [:"~", :backtick],
      KB_MINUS             => [:minus],
      KB_EQUALS            => [:"=", :equal],
      KB_LEFT_BRACKET      => [:"}", :bracket_left],
      KB_RIGHT_BRACKET     => [:"{", :bracket_right],
      KB_BACKSLASH         => [:backslash],
      KB_SLASH             => [:slash],
      KB_SEMICOLON         => [:";", :semicolon],
      KB_PERIOD            => [:period],
      KB_ISO               => [:ISO],

      KB_NUMPAD_PLUS      => [:"+", :add, :plus],
      KB_NUMPAD_DIVIDE    => [:"/", :divide],
      KB_NUMPAD_MULTIPLY  => [:"*", :multiply],
      KB_NUMPAD_MINUS     => [:"-", :subtract, :numpad_minus, :nm_minus],
      KB_PAGE_DOWN        => [:page_down],
      KB_PAGE_UP          => [:page_up],
      KB_PAUSE            => [:pause],
      KB_RETURN           => [:return],
      KB_RIGHT            => [:right_arrow, :right],
      KB_RIGHT_ALT        => [:right_alt, :ralt],
      KB_RIGHT_CONTROL    => [:right_control, :right_ctrl, :rctrl],
      KB_RIGHT_SHIFT      => [:right_shift, :rshift],
      KB_RIGHT_META       => [:right_meta, :rmeta],
      KB_SPACE           => [:" ", :space],
      KB_TAB             => [:tabulator, :tab],
      KB_UP              => [:up_arrow, :up],
      KB_PRINT_SCREEN      => [:print_screen],
      KB_SCROLL_LOCK       => [:scroll_lock],
      KB_CAPS_LOCK        => [:caps_lock],
      KB_NUMPAD_DELETE     => [:numpad_delete],
      
      MS_LEFT             => [:left_mouse_button, :mouse_left],
      MS_MIDDLE           => [:middle_mouse_button, :mouse_middle],
      MS_RIGHT            => [:right_mouse_button, :mouse_right],
      MS_WHEEL_DOWN       => [:mouse_wheel_down, :wheel_down],
      MS_WHEEL_UP         => [:mouse_wheel_up, :wheel_up],

      GP_DPAD_LEFT            => [:dpad_left],
      GP_DPAD_RIGHT           => [:dpad_right],
      GP_DPAD_UP              => [:dpad_up],
      GP_DPAD_DOWN            => [:dpad_down],
      GP_LEFT_STICK_Y_AXIS    => [:left_stick_y_axis],
      GP_LEFT_STICK_X_AXIS    => [:left_stick_x_axis],
      GP_LEFT_TRIGGER_AXIS    => [:left_rigger_axis],
      GP_RIGHT_STICK_Y_AXIS   => [:left_stick_x_axis],
      GP_RIGHT_STICK_X_AXIS   => [:right_stick_y_axis],
      GP_RIGHT_TRIGGER_AXIS   => [:right_rigger_axis],
    }

    (0..9).each do |number|
      CONSTANT_TO_SYMBOL[eval("KB_#{number}")] = ["ms_other_#{number.to_s}".to_sym]
    end

    # MsOther, 0-7
    (0..7).each do |number|
      CONSTANT_TO_SYMBOL[eval("MS_OTHER_#{number}")] = ["ms_other_#{number.to_s}".to_sym]
    end
    
    # Letters, A-Z
    ("A".."Z").each do |letter|
      CONSTANT_TO_SYMBOL[eval("KB_#{letter}")] = [letter.downcase.to_sym]
    end

    # Numbers, 0-9
    (0..9).each do |number|
      CONSTANT_TO_SYMBOL[eval("KB_#{number.to_s}")] = [number.to_s.to_sym]
    end

    # Numpad-numbers, 0-9
    (0..9).each do |number|
      CONSTANT_TO_SYMBOL[eval("KB_NUMPAD_#{number.to_s}")] = ["numpad_#{number.to_s}".to_sym]
    end

    #F-keys, F1-F12
    (1..12).each do |number|
      CONSTANT_TO_SYMBOL[eval("KB_F#{number.to_s}")] = ["f#{number.to_s}".to_sym, "F#{number.to_s}".to_sym]
    end

    (0..3).each do |number|
      CONSTANT_TO_SYMBOL[eval("GP_#{number.to_s}_DPAD_LEFT")] = ["dpad_#{number.to_s}_left".to_sym]
      CONSTANT_TO_SYMBOL[eval("GP_#{number.to_s}_DPAD_RIGHT")] = ["dpad_#{number.to_s}_right".to_sym]
      CONSTANT_TO_SYMBOL[eval("GP_#{number.to_s}_DPAD_UP")] = ["dpad_#{number.to_s}_up".to_sym]
      CONSTANT_TO_SYMBOL[eval("GP_#{number.to_s}_DPAD_DOWN")] = ["dpad_#{number.to_s}_down".to_sym]
    end

    def gamepad_key(number, key, args = {})
      number = number.zero? ? '' : number - 1

      constant_name = ["GP", number.to_s]
      constant_name << args[:prefix].to_s.upcase
      constant_name << key.to_s.to_s.upcase
      constant_name = constant_name.compact.flatten.reject(&:empty?)

      CONSTANT_TO_SYMBOL[eval(constant_name.join('_'))] = [
          "gamepad_button#{number}_#{key}".to_sym,
          "gamepad#{number}_#{key}".to_sym,
          "pad_button#{number}_#{key}".to_sym,
          "pad#{number}_#{key}".to_sym,
          "gp#{number}_#{key}".to_sym
      ]
    end

    module_function :gamepad_key

    # Gamepads
    (0..4).each do |gp_number|
      gamepad_key(gp_number, :down)
      gamepad_key(gp_number, :left)
      gamepad_key(gp_number, :right)
      gamepad_key(gp_number, :up)

      # Gamepad-buttons 0-15
      (0..15).each { |n| gamepad_key(gp_number, n, prefix: 'button') }
    end

    #
    # Reverse CONSTANT_TO_SYMBOL -> SYMBOL_TO_CONSTNT
    # like: SYMBOL_TO_CONSTANT = CONSTANT_TO_SYMBOL.invert.dup
    #
    SYMBOL_TO_CONSTANT = Hash.new
    CONSTANT_TO_SYMBOL.each_pair do |constant, symbols|
      symbols.each do |symbol|
        SYMBOL_TO_CONSTANT[symbol] = constant
      end
    end
    
  end
end
