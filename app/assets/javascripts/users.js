// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function() {
  Materialize.updateTextFields();

  $('.play').click(function(e){
    e.preventDefault();
    var pause = this.parentElement.nextElementSibling;
    var url = $(this).data("url");

    if($(this).hasClass('clicked')) {
      $('#player').get(0).play();
    }else {
      $('#player').prop('src', url);
      $(this).addClass('clicked')
    }
    $(pause).removeClass("inactive");
    $(this.parentElement).addClass("inactive");

    $('#player').on('ended', function(){
      var id = $(this).data("id");
      $.ajax({
        url: '/user_articles/'+ id,
        method: 'patch'
      });
    }.bind(this));
  });

  $('.pause').click(function(e){
    var pause = this.parentElement.previousElementSibling;
    $('#player').get(0).pause();
    $(pause).removeClass("inactive");
    $(this.parentElement).addClass("inactive");
  });

  $('.article').on('click', '.show-text', function(e) {
    var text = this.parentElement.lastChild.previousElementSibling;
    if($(text).is(":hidden")) {
      $('.text-scroll-container').hide();
      $(text).slideToggle();
    } else {
      $(text).slideToggle();
    }
  });


});
