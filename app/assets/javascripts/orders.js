var admin = {
  init: function(){
    admin.set_admin_selectable_events();
  },

  set_admin_selectable_events: function(){
    $("select.admin-selectable").on("change", function(e){
      var path        = $( e.currentTarget ).attr("data-path");
      var attr        = $( e.currentTarget ).attr("data-attr");
      var resource_id = $( e.currentTarget ).attr("data-resource-id");
      var val         = $( e.currentTarget ).val();

      val = $.trim(val)

      var payload = {}
      resource_class = path.slice(0,-1)
      payload[resource_class] = {};
      payload[resource_class][attr] = val;

      $.ajax({
        url: "/admin/"+path+"/"+resource_id,
        type: 'PUT',
        data: payload
      });
    });
  }
}

document.addEventListener("turbolinks:load", function() {
  admin.init();
});
