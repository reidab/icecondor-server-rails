  function pollIcecondor(id) {
    $('icecondor').innerHTML = "loading last IceCondor update.";
    new Ajax.Request('http://www.icecondor.com/locations.json?id='+id, {
      method: 'get',
      onSuccess: function(response) {
        $('icecondor').innerHTML = "last checkin: "+response.responseJSON[0].location['timestamp'];
      }
    });
  }


