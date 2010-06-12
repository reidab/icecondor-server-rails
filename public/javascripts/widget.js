  // jQuery required
  // Load json data from www.icecondor.com and display it in the #icecondor span
  function pollIcecondor(id, delay) {
    setInterval(
     "add_script_tag('http://www.icecondor.com/locations.pjson?id="+id+"')",
     delay * 1000);

//    $.ajax({ url: "http://www.icecondor.com/locations.json?id="+id, 
//             context: document.body, 
//             success: function(response, rstatus,xhp){
//                         alert('Load was performed.'+response+rstatus+xhp);}});
  }

function add_script_tag(url) {
  var s = document.createElement('script');
  s.type = 'text/javascript';
  s.src = url;
  document.getElementsByTagName('head')[0].appendChild(s);
} 
