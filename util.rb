# frozen_string_literal: true

require 'io/console'
require 'tty/reader'

## Utility methods, shared between all classes
module Util
  ## Spin up a new thread to run a given block at an interval
  # @param {Number} delay - The time, in seconds, to use for a delay
  # Mind the yield, this method also takes a block
  def self.poll(delay)
    Thread.new do
      loop do
        sleep delay
        yield
      end
    end
  end

  ### TODO: Add more keyboard listeners -- one to pause the feed, one to follow
  #         a link (if in CLI mode...?) etc.
  def self.listen_for_exit
    @reader = TTY::Reader.new
    Util.poll(Cli::CLI_SPEED) do
      exit if @reader.read_char == 'q'
      Util.clear_term
    end
  end

  ### TODO: this might make more sense as a Display::Cli method.
  def self.clear_term
    Thread.new do
      sleep Cli::CLI_SPEED
      system('clear') ? nil : system('cls')
    end
  end
end
