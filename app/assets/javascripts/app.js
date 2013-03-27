$(document).ready(function() {

  $('#routes > li').click(function(e) {
    //real_time/fetch.json?stop_id=1_75403&route=65&sched_time=1364337615
    var url = "/real_time/fetch.json";

    console.log('i clicked');
    $('#routes .steps').slideUp('fast');
    $(this).find('.steps').slideDown('fast').addClass('active');

    var stops = $(this).find('.real-time');

    $.each(stops, function() {
      var stop = $(this);
      console.log($(this).data('stop-id'));

      url += "?stop_id=" + $(this).data('stop-id');
      url += "&route=" + $(this).data('route-id');
      url += "&sched_time=" + $(this).data('departure-time');

      $.ajax({
        type: "GET",
        url: url,
        dataType: "json",
        success: function(data) {
          console.log(data);


          if(data.status !== "on time") {
            stop.text(Math.abs(data.m) + "m" + data.s + "s " + data.status);
          } else {
            stop.text(data.status);
          }

        }
      });
    });
  });
});

