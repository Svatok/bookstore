module ActiveAdmin
  module Views
    class IndexAsTable < ActiveAdmin::Component
      include CustomHelper

      def column_select resource, attr, list
        val = resource.send(attr)

        html = _select list, val, { "attrs" => %{
                                                    data-path='#{resource.class.name.tableize}'
                                                    data-attr='#{attr}'
                                                    data-resource-id='#{resource.id}'
                                                    class='admin-selectable'
                                                }
                                  }
        html.html_safe
      end
    end
  end
end
