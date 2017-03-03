document.addEventListener("turbolinks:load", function() {
  $(".input-link").on("click", function(e) {
    e.preventDefault();
    var $button = $(this);
    var parent_form_action = $button.parents('.edit_order_item').attr('action');
    var oldValue = $button.parent().find(".form-control.quantity-input").val();
    if ($button.children().attr('class') == 'fa fa-plus line-height-40') {
  	  var newVal = parseFloat(oldValue) + 1;
  	} else {
      if (oldValue > 0) {
        var newVal = parseFloat(oldValue) - 1;
      } else {
        newVal = 0;
      }
    }
    $("form[action='" + parent_form_action + "']").each(function() {
      $(this).find(".form-control.quantity-input").val(newVal);
    });
  });

  $(".in-grey-600.small.line-height-2").shorten({
  	"showChars" : 150,
  	"moreText"	: "Read More",
  	"lessText"	: "Less",
    "classMore"	: "in-gold-500 ml-10",
  });

  $(".img-link").on("click", function(e) {
    e.preventDefault();
    var img_path = $(this).children().attr('src');
    $('.img-responsive').attr('src', img_path);
  });

  /* 1. Visualizing things on Hover - See next part for action on click */
  $('#stars li').on('mouseover', function(){
    var onStar = parseInt($(this).data('value'), 10); // The star currently mouse on

    // Now highlight all the stars that's not after the current hovered star
    $(this).parent().children('li.star').each(function(e){
      if (e < onStar) {
        $(this).addClass('hover');
      }
      else {
        $(this).removeClass('hover');
      }
    });

  }).on('mouseout', function(){
    $(this).parent().children('li.star').each(function(e){
      $(this).removeClass('hover');
    });
  });


  /* 2. Action to perform on click */
  $('#stars li').on('click', function(){
    var onStar = parseInt($(this).data('value'), 10); // The star currently selected
    var stars = $(this).parent().children('li.star');

    for (i = 0; i < stars.length; i++) {
      $(stars[i]).removeClass('selected');
    }

    for (i = 0; i < onStar; i++) {
      $(stars[i]).addClass('selected');
    }

    // JUST RESPONSE (Not needed)
    var ratingValue = parseInt($('#stars li.selected').last().data('value'), 10);
    $('#rate_value').val(ratingValue);
  });

})
