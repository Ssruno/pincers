module Pincers::Extension
  module Queries

    TEXT_INPUTS = ['text', 'email', 'number', 'email', 'color', 'password', 'search', 'tel', 'url']

    def id
      self[:id]
    end

    def value
      case input_mode
      when :checkbox, :radio
        if checked? then self[:value] else nil end
      else
        self[:value]
      end
    end

    [:selected, :checked, :disabled, :required].each do |attr_name|
      define_method "#{attr_name}?" do
        self[attr_name]
      end
    end

    def classes
      (self[:class] || '').split(' ')
    end

    def selected(_options={})
      first!.search('option', _options).select(&:selected?)
    end

    def checked(_options={})
      first!.search('input', _options).select(&:checked?)
    end

    def input_mode
      return :select if tag == 'select'
      return :button if tag == 'button' # TODO: button types
      return :text if tag == 'textarea'
      return nil if tag != 'input'

      type = (self[:type] || 'text').downcase
      return :text if TEXT_INPUTS.include? type
      type.to_sym
    end

    def download
      url = attribute(:href) || attribute(:src)
      raise Pincers::NavigationError.new(self, 'No resource url was found') if url.nil?
      root.download(attribute(:href) || attribute(:src))
    end

  end
end