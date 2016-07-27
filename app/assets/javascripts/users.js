$(document).ready(function() {
  Materialize.updateTextFields();

  $('.play').click(function(e){
    e.preventDefault();
    var pause = this.parentElement.nextElementSibling;
    var url = $(this).data("url");
    var a = $(".pause");
    for (var i = 0; i < a.length; i ++) {
      var c = $(a[i].parentElement);
        if (!c.hasClass('inactive')) {
          c.addClass('inactive');
        }
        }
    var b = $(".play");
      for (i = 0; i < b.length; i ++){ $(b[i].parentElement).removeClass('inactive'); }

    $(this.parentElement).addClass('last-play');
    if($(this).hasClass('clicked')) {
      $('#player').get(0).play();
    }else {
      $('#player').prop('src', url);
      $(this).addClass('clicked');
    }

    $(pause).removeClass("inactive");
    $(pause).show();
    $(this.parentElement).addClass("inactive");

    $('#player').on('ended', function(){
      var id = $(this).data("id");
      var new_history = document.getElementById(id);
      $(new_history).remove();
      $('#history').append(new_history);
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

  $('#history').on('click', "h4", function(e) {
    $("#queue").removeClass('inactive');
    $("#history").addClass('inactive');
  });

  $('#queue').on('click', "h4", function(e) {
    $("#history").removeClass('inactive');
    $("#queue").addClass('inactive');
  });


  // Spinner
  var opts = {
    lines: 10 // The number of lines to draw
  , length: 20 // The length of each line
  , width: 6 // The line thickness
  , radius: 27 // The radius of the inner circle
  , scale: 0.27 // Scales overall size of the spinner
  , corners: 1 // Corner roundness (0..1)
  , color: '#00BFFF' // #rgb or #rrggbb or array of colors
  , opacity: 0.6 // Opacity of the lines
  , rotate: 0 // The rotation offset
  , direction: 1 // 1: clockwise, -1: counterclockwise
  , speed: 1.3 // Rounds per second
  , trail: 20 // Afterglow percentage
  , fps: 20 // Frames per second when using setTimeout() as a fallback for CSS
  , zIndex: 2e9 // The z-index (defaults to 2000000000)
  , className: 'spinner' // The CSS class to assign to the spinner
  , top: '45%' // Top position relative to parent
  , left: '50%' // Left position relative to parent
  , shadow: true // Whether to render a shadow
  , hwaccel: false // Whether to use hardware acceleration
  , position: 'absolute' // Element positioning
  };

  $('#url-form').submit(function(e){
    e.preventDefault();

    var target = $(e.target);
    var button2 = document.getElementsById("read-button")[0];
    button2.firstChild.style.visibility="hidden";
    var spinner = new Spinner(opts).spin(button2);
    var entered_url = $('#article_url').val();
    var button = $(this).find('input[type=submit]');
    button.prop('disabled', true);

    var request = $.ajax({
      url: target.attr('action'),
      method:target.attr('method'),
      data: { "article" : { "url": entered_url } }
    });
    request.done(function(response){
      spinner.stop();
      button2.firstChild.style.visibility="visible";
      $('#queue').html(response);
      button.prop('disabled', false);
      document.getElementById("article_url").value = "";
    });
    request.fail(function(response){
      spinner.stop();
      button2.firstChild.style.visibility="visible";
      button.prop('disabled', false);
      var errorMessage = JSON.parse(response.responseText).error;
      $('#url-error').html(errorMessage);
      document.getElementById("article_url").value = "";
    });
  });
});
