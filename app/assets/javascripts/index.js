$(document).ready(function() {
  $(".button-collapse").sideNav({
    menuWidth: 200,
    edge: 'left',
    closeOnClick: true
  });
  $('#trending').on('submit','#new_user_article',function(e){
    e.preventDefault();
    $.ajax({
      url: $(this).attr('action'),
      method:$(this).attr('method'),
      data:$(this).serialize()
    }).done(function(response){
      $('#trending').html(response);
    });
  });
});



