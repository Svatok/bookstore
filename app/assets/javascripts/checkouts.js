document.addEventListener("turbolinks:load", function() {


  var parent_div = $('.billing-use').parents('.shipping-form');
  var sipping_form_elements = parent_div.find('.form-group');
  var visible_title_div = parent_div.find('.visible-xs.visible-sm');
  var hidden_title_div = parent_div.find('.address-title.hidden');

  if($('.billing-use').is(":checked")) {
    sipping_form_elements.each(function(e){
      var current_class = $(this).attr('class');
      if (current_class == 'form-group checkbox') {
        return true;
      }
      $(this).attr('class', current_class + " hidden" );
    });
    visible_title_div.attr('class', "address-title hidden" );
  }

  $('.billing-use').change(function() {

    if($(this).is(":checked")) {
      sipping_form_elements.each(function(e){
        var current_class = $(this).attr('class');
        if (current_class == 'form-group checkbox') {
          return true;
        }
        $(this).attr('class', current_class + " hidden" );
      });
      visible_title_div.attr('class', "address-title hidden" );
      return;
    }
    sipping_form_elements.each(function(e){
      var current_class = $(this).attr('class');
      if (current_class == 'form-group checkbox') {
        return true;
      }
      $(this).attr('class',  "form-group" );
    });
    hidden_title_div.attr('class', "visible-xs visible-sm" );
  });

})
