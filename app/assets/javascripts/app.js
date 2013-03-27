$(document).ready(function() {

  $('#routes > li').click(function(e) {
    //real_time/fetch.json?stop_id=1_75403&route=65&sched_time=1364337615


    console.log('i clicked');
    $('#routes .steps').slideUp('fast');
    $(this).find('.steps').slideDown('fast').addClass('active');

    var stops = $(this).find('.real-time');

    $.each(stops, function() {
      var stop = $(this);
      console.log($(this).data('stop-id'));

      var url = "/real_time/fetch.json";
      url += "?stop_id=" + stop.data('stop-id');
      url += "&route=" + stop.data('route-id');
      url += "&sched_time=" + stop.data('departure-time');

      $.ajaxQueue({
        type: "GET",
        url: url,
        dataType: "json",
        success: function(data) {
          console.log(data);


          if(data.status) {
            if(data.m) {
              stop.text(Math.abs(data.m) + "m" + data.s + "s " + data.status);
            } else {
              stop.text(data.status);
            }
          } else {
            stop.text("??");
          }

        }
      });
    });
  });
});

