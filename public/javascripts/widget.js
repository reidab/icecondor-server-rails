  // jQuery required
  // Load json data from www.icecondor.com and display it in the #icecondor span
  function pollIcecondor(id, delay) {
    setInterval(
     "add_script_tag('http://www.icecondor.com/locations.jsonp?id="+id+"')",
     delay * 1000);
  }

  function callback(data) {
    var ic = document.getElementById('icecondor');
    ic.innerHTML = "Last IceCondor location updated at "+data[0].location.timestamp;
  }

  function add_script_tag(url) {
    var s = document.createElement('script');
    s.type = 'text/javascript';
    s.src = url;
    document.getElementsByTagName('head')[0].appendChild(s);
  } 
