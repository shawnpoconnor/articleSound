$(document).ready(function() {
  $(".button-collapse").sideNav({
    menuWidth: 200, // Default is 240
    edge: 'right', // Choose the horizontal origin
    closeOnClick: true 
  });
  $('#new_user_article').submit(function(e){
    e.preventDefault();
    $.ajax({
      url: $(this).attr('action'),
      method:$(this).attr('method'),
      data:$(this).serialize()
    }).done(function(response){
      $('#trending').html(response);
    })
  })
})


        