module Pincers::Extension
  module Queries

    TEXT_INPUTS = ['text', 'email', 'number', 'email', 'color', 'password', 'search', 'tel', 'url']

    def value
      self[:value]
    end

    def selected?
      not self[:selected].nil?
    end

    def checked?
      not self[:checked].nil?
    end

    def classes
      (self[:class] || '').split(' ')
    end

    def selected(_options={})
      first!.css('option[selected]', _options)
    end

    def checked(_options={})
      first!.css('input[checked]', _options)
    end

    def input_mode
      return :select if tag == 'select'
      return :button if tag == 'button'
      return :text if tag == 'textarea'
      return nil if tag != 'input'

      type = (self[:type] || 'text').downcase
      return :text if TEXT_INPUTS.include? type
      type.to_sym
    end

  end
end