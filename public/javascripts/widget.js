  // jQuery required
  // Load json data from www.icecondor.com and display it in the #icecondor span
  function pollIcecondor(id, delay) {
     add_script_tag('http://www.icecondor.com/locations.jsonp?id='+id+'&callback=icPosition&limit=1');
  }

  function icPosition(data) {
    var ic = document.getElementById('icecondor');
    var utctime = Date.parse(data[0].location.timestamp);
    var offset = new Date().getTimezoneOffset();
    var datetime = new Date(utctime-(offset*60*1000))
    ic.innerHTML = "Last IceCondor location updated at "+datetime;
  }

  function add_script_tag(url) {
    var s = document.createElement('script');
    s.type = 'text/javascript';
    s.src = url;
    document.getElementsByTagName('head')[0].appendChild(s);
  } 
