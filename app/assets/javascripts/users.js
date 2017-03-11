document.addEventListener("turbolinks:load", function() {

  $('#remove').change(function() {
     if($(this).is(":checked")) {
       $('#remove_button').attr('class', 'btn btn-default mb-20')
        return;
     }
     $('#remove_button').attr('class', 'btn disabled mb-20')
  });

})
