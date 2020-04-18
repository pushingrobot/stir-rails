(function() {
  function stir_device(id) {
    $.ajax({
      url: '/stir/' + id,
      method: 'get',
      dataType: 'json',
      success: (data, textStatus, jqXHR) => {
        if (textStatus == 'ok') {
          poll_devices(id);
        }
      }
    });
  }

  function poll_devices(id) {
    $('#device_' + id).addClass('polling');
    $.ajax({
      url: '/poll/' + id,
      method: 'get',
      dataType: 'json',
      success: (data, textStatus, jqXHR) => {
        if (data && data.results) {
          $.map(data.results, function(dev) {
            var $element = $('#device_' + dev.id);
            var $progress = $element.find('.progress');
            if (dev.ready == true) {
              // device is ready, remove the progress bar and color it as active
              $element.removeClass('polling').addClass('active');
              $progress.width('0%').data('width', 0);
            } else if ($element.hasClass('clicked')) {
              // device is being polled, show the progress bar
              var width = $progress.data('width');
              width = width + 2;
              if (width > 100) {
                // give up
                $progress.width('0%').data('width', 0);
                $element.removeClass('polling active')
              } else {
                // show progress
                $progress.width(width + 2 + '%').data('width', width);
                poll_devices(id);
              }
            }
          });
        }
      }
    });
  }
  
  function ready() {
    if ($('.device').length > 0) {
      poll_devices('all');
    }
  
    $('a.device').on('click', function(e) {
      var $this = $(this);
      var device_id = $this.data('id');
      e.preventDefault();
      $this.addClass('clicked');
      stir_device(device_id);
      poll_devices(device_id);
    })
  }
  
  $(document).on('turbolinks:load', ready)
  // $(document).ready(ready);
})();
