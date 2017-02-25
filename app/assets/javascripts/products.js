$(document).ready(function() {
  $(".input-link").on("click", function(e) {
    e.preventDefault();
    var $button = $(this);
    var oldValue = $button.parent().find("input").val();
    if ($button.children().attr('class') == 'fa fa-plus line-height-40') {
  	  var newVal = parseFloat(oldValue) + 1;
  	} else {
      if (oldValue > 0) {
        var newVal = parseFloat(oldValue) - 1;
      } else {
        newVal = 0;
      }
    }

    $button.parent().find("input").val(newVal);
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
})
