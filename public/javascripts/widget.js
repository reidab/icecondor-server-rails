  // jQuery required
  // Load json data from www.icecondor.com and display it in the #icecondor span
  function pollIcecondor(id) {
    $.ajax({ url: "http://www.icecondor.com/locations.json?id="+id, context: document.body, success: function(response, rstatus,xhp){
               alert('Load was performed.'+response+rstatus+xhp);
                  }});
  }


