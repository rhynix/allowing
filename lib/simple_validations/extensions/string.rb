module SimpleValidations
  module Extensions
    module String
      refine ::String do
        def classify
          split('_').map(&:capitalize).join
        end

        def underscore
          gsub(/([A-Z\d])([A-Z][a-z])/, '\1_\2')
            .gsub(/([a-z\d])([A-Z])/, '\1_\2')
            .downcase
        end
      end
    end
  end
end
