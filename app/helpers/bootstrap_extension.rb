  module BootstrapExtension
    FORM_CONTROL_CLASS = "form-control"

    # Override the 'text_field' method defined in FormTagHelper[1]
    #
    # [1] https://github.com/rails/rails/blob/master/actionview/lib/action_view/helpers/form_tag_helper.rb
    def text_field(name, value = nil, options = {})
      class_name = options[:class]
      # if class_name.nil?
      #   # Add 'form-control' as the only class if no class was provided
      #   options[:class] = FORM_CONTROL_CLASS
      # else
      #   # Add ' form-control' to the class if it doesn't already exist
      #   options[:class] << " #{FORM_CONTROL_CLASS}" if
      #     " #{class_name} ".index(" #{FORM_CONTROL_CLASS} ").nil?
      # end
      options[:class] = options[:class] || "#{FORM_CONTROL_CLASS}"

      # Call the original 'text_field_tag' method to do the real work
      super
    end

    def password_field_tag(name, value = nil, options = {})
      class_name = options[:class]
      if class_name.nil?
        options[:class] = FORM_CONTROL_CLASS
      else
        options[:class] << " #{FORM_CONTROL_CLASS}" if
          " #{class_name} ".index(" #{FORM_CONTROL_CLASS} ").nil?
      end
      super
    end
  end