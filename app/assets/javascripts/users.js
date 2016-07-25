// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function() {
    Materialize.updateTextFields();

    $('.play').click(function(e){
      var url = $(this).data("url");
      $('#player').prop('src', url);
    });

    $('.article').on('click', '.show-text', function(e) {
      var text = this.parentElement.firstChild.nextSibling.nextSibling.nextSibling
      if($(text).is(":hidden")) {
        $('.text-scroll-container').hide()
        $(text).slideToggle();
      } else {
        $(text).slideToggle();
      }
    });

  });
