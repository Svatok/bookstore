module CustomHelper
  def _select(set, selected, options = {})
    selected = options['default'] if selected.blank?
    id ||= "ch#{ch_uniq_id}" unless options['cache'].blank?
    html = select_list_open_tag(options, id)
    html << options_html(set, selected, options)
    html << '</select>'
    html << add_js(id, selected) unless options['cache'].blank?
    html
  end

  def ch_uniq_id
    @ch_uniq_id ||= Time.now.to_i
    @ch_uniq_id += 1
  end

  def select_list_open_tag(options, id)
    style = "margin:0;padding:0;#{options['style']}"
    html = "<select style='#{style}' #{options['attrs']} "
    html << " data-cache='#{options['cache']}' " unless options['cache'].blank?
    html << " id='#{id}' " unless id.blank?
    html << '>'
  end

  def options_html(set, selected, options)
    return '<option></option>' if options['blank']
    return _select_options(set, selected, options) if options['cache'].blank?
    Rails.cache.fetch("CustomHelper:#{options['cache']}", expires_in: 1.minute) do
      _select_options set, selected, options
    end
  end

  def _select_options(set, selected, options)
    html = ''
    arr_match = options['arr_match'] || 0
    set.each do |option|
      option = option[1] if option.is_a? Array
      html << generate_html_option(option_settings(option, arr_match), selected, option)
    end
    html
  end

  def option_settings(option, arr_match)
    settings = {}
    settings[:check] = option
    settings[:value] = option
    return settings unless option.is_a? Array
    settings[:check]  = option[arr_match]
    settings[:value]  = option[0]
    settings
  end

  def generate_html_option(settings, selected, option)
    if selected.to_s.strip == settings[:check].to_s.strip
      return "<option value='#{settings[:value]}' selected>#{option}</option>"
    end
    "<option value='#{settings[:value]}'>#{option}</option>"
  end

  def add_js(id, selected)
    %{
      <script type="text/javascript">
        $( document ).ready(function() {
          $("select##{id}").val("#{selected.to_s.strip}");
        });
      </script>
    }
  end
end
