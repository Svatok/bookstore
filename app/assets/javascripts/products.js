document.addEventListener("turbolinks:load", function() {
  $(".input-link").on("click", function(e) {
    e.preventDefault();
    var $button = $(this);
    var oldValue = $button.parent().find(".quantity-input").val();
    if ($button.children().attr('class') == 'fa fa-plus line-height-40') {
  	  var newVal = parseFloat(oldValue) + 1;
  	} else {
      if (oldValue > 0) {
        var newVal = parseFloat(oldValue) - 1;
      } else {
        newVal = 0;
      }
    }

    $button.parent().find(".quantity-input").val(newVal);
  });

  $(".shorten-description").shorten({
  	"showChars" : 200,
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

  var max_fields      = 10; //maximum input boxes allowed
  var add_button      = $(".add_field_button"); //Add button ID
  var new_characteristics_count = 0;

  $(add_button).click(function(e){ //on add input button click
    e.preventDefault();
    var wrapper = $(this).parent('div'); //Fields wrapper
    var select_list = wrapper.siblings('select.hidden'); //Fields wrapper
    var new_div = $("<div></div>");
    var name_add_element = wrapper.siblings('h4').html().toLowerCase().slice(0,-1);
    new_characteristics_count += 1

    if (name_add_element == 'authors') {
      select_list.clone().removeClass('hidden').attr('name', 'product[' + name_add_element + '][]').appendTo(new_div);
    }else{
      select_list.clone().removeClass('hidden').attr('name', 'product[' + name_add_element + '[new' + new_characteristics_count + ']][property_id]').appendTo(new_div);
      new_div.append('<input class="form-control" placeholder="Value..." name="product[' + name_add_element + '[new' + new_characteristics_count + ']][value]" type="text">');
    }
    new_div.append('<a href="#" class="remove_field">Remove</a>');
    $(new_div).insertBefore($(this));
  });

  $('body').on("click",".remove_field", function(e){ //user click on remove text
      e.preventDefault(); $(this).parent('div').remove(); x--;
  })

})
