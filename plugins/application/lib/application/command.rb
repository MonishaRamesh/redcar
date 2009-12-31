module Redcar
  # A Redcar::Command class encapsulates a block of code, along with metadata
  # to describe in what ways it can be called, and how Redcar will treat the
  # command instances.
  #
  # Define commands by subclassing the Redcar::Command class.
  #
  # ## Examples
  #
  #     class CloseTab < Redcar::Command
  #       key  :linux   => "Ctrl+W",
  #            :osx     => "Cmd+W",
  #            :windows => "Ctrl+W"
  #     
  #       def execute
  #         tab.close if tab
  #       end
  #     end
  class Command
    attr_accessor :error
    
    extend Redcar::Observable
    extend Redcar::Sensitive

    def self.inherited(klass)
      klass.send(:extend, Redcar::Sensitive)
      klass.sensitize(*sensitivity_names)
    end
    
    # Called by the Sensitive module when the active value of this changed
    def self.active_changed(value)
      notify_listeners(:active_changed, value)
    end
    
    def self.key(key)
      @key = key
    end
    
    def self.get_key
      @key
    end
    
    def self.norecord
      @record = false
    end
    
    def self.record?
      @record == nil or @record
    end
    
    def environment(env)
      @env = env
    end
    
    def run(opts = {})
      @executor = Executor.new(self, opts)
      @executor.execute
    end
    
    private
    
    def env
      @env || {}
    end
    
    def win
      env[:win]
    end
    
    def tab
      env[:tab]
    end
  end
end
