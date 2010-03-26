  function pollIcecondor(id) {
    $('icecondor').innerHTML = "IceCondor goes here.";
    new Ajax.Request('http://www.icecondor.com/locations.json?id='+id, {
      method: 'get',
      onLoading: function(response) {
        $('icecondor').innerHTML = "loading last IceCondor update.";
      },
      onSuccess: function(response) {
        $('icecondor').innerHTML = "last checkin: "+response.responseJSON[0].location['timestamp'];
      }
    });
  }


