$(document).ready(function() {
  $('form').submit(function(e){
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