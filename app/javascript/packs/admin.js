"use strict";

// document.placeholder_host = {
//   id: ',',
//   host: 'Enter a device manually',
//   ip: '',
//   mac: '',
//   oui: '',
//   updated_at: ''
// }

document.placeholder_host = {
  id: ',',
  text: 'Search for a network device',
}
document.known_hosts = [document.placeholder_host];

var deviceLookupOptions = {
  placeholder: document.placeholder_host,
  ajax: {
    transport: function(params, success, failure) {
      var items = document.known_hosts;
      // fitering if params.data.q available
      if (params.data && params.data.q) {
          items = items.filter(function(item) {
              return new RegExp(params.data.q).test(item.text);
          });
      }
      var promise = new Promise(function(resolve, reject) {
          resolve({results: items});
      });
      promise.then(success);
      promise.catch(failure);
    }
  }
}

// ,
//   templateResult: formatDevice,
//   templateSelection: formatSelection
//}

function formatDevice(device) {
  return $("<span>" + device.text + "</span>");
}

function formatSelection(device) {
  return device.text;
}

$(document).on('turbolinks:load', function() {
  $('.devices').on('cocoon:after-insert', function(e, insertedItem, originalEvent) {
    var $select2 = $(insertedItem).find('.select2-device-lookup')
    $select2.select2(deviceLookupOptions);
    refresh_devices();
  });

  var $deviceLookup = $('.select2-device-lookup')

  if ($deviceLookup.length > 0) {
    refresh_devices();
  }

  $deviceLookup.select2(deviceLookupOptions);

  $('.devices').on('select2:select', function (e) {
    var [host, mac] = e.params.data.id.split(',');
    $(e.target).parents('.device').find('input[name$="[mac]"]').val(mac);
    $(e.target).parents('.device').find('input[name$="[host]"]').val(host);
  });

  function formatRepo (repo) {
    if (repo.loading) {
      return repo.text;
    }
  
    var $container = $(
      "<div class='select2-result-repository clearfix'>" +
        "<div class='select2-result-repository__avatar'><img src='" + repo.owner.avatar_url + "' /></div>" +
        "<div class='select2-result-repository__meta'>" +
          "<div class='select2-result-repository__title'></div>" +
          "<div class='select2-result-repository__description'></div>" +
          "<div class='select2-result-repository__statistics'>" +
            "<div class='select2-result-repository__forks'><i class='fa fa-flash'></i> </div>" +
            "<div class='select2-result-repository__stargazers'><i class='fa fa-star'></i> </div>" +
            "<div class='select2-result-repository__watchers'><i class='fa fa-eye'></i> </div>" +
          "</div>" +
        "</div>" +
      "</div>"
    );
  
    $container.find(".select2-result-repository__title").text(repo.full_name);
    $container.find(".select2-result-repository__description").text(repo.description);
    $container.find(".select2-result-repository__forks").append(repo.forks_count + " Forks");
    $container.find(".select2-result-repository__stargazers").append(repo.stargazers_count + " Stars");
    $container.find(".select2-result-repository__watchers").append(repo.watchers_count + " Watchers");
  
    return $container;
  }

  function refresh_devices() {
    $.ajax({
      url: '/admin/lookup',
      method: 'get',
      dataType: 'json',
      success: (data, textStatus, jqXHR) => {
        if (data && data.results) {
          var new_hosts = $.map(data.results, (obj) => {
            return {
              id: obj.identifier,
              text: obj.host + ' (' + obj.mac + ')'
            }
          });
        }
        new_hosts.unshift(document.placeholder_host);
        document.known_hosts = new_hosts
        $('.select2-device-lookup').select2({data: document.known_hosts});
      }
    });
  }
});
