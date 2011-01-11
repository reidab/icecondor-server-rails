/* geopoly.js edit a polygon on top of a google map */

 google.maps.Polygon.prototype.push = function(latlng) {
   var new_points = this.getPath();
   var new_len = new_points.push(latlng);
   this.setPath(new_points);
   this.addHandle(latlng, new_len-1);
 }

 google.maps.Polygon.prototype.addHandle = function(latlng, idx) {
   var cops = { center : latlng,
                radius : 1,
                map : this.getMap() }
   var handle = new google.maps.Circle(cops)
   handle.polyFenceIndex = idx;   
   google.maps.event.addListener(handle, 'mousedown', handle.mouseDown);
   google.maps.event.addListener(handle, 'mouseup', handle.mouseUp);
   google.maps.event.addListener(this.getMap(), 'idle', function(handle){return function(){handle.mapIdle()}}(handle));
   this.handles.push(handle);
 }

 google.maps.Polygon.prototype.setGeoJsonPath = function(geojson) {
  var points = geojson.coordinates[0];
  var bounds = new google.maps.LatLngBounds();
  for(var i=0,len=points.length; i<len; i++) {
    var point = points[i];
    point = new google.maps.LatLng(point[0], point[1]);
    this.push(point);
    bounds.extend(point);
  }
  this.getMap().fitBounds(bounds);
 }

 google.maps.Circle.prototype.mouseDown = function(event) {
  this.getMap().setOptions({draggable: false});
  if(!this.handleMoveListener) {
    this.handleMoveListener = google.maps.event.addListener(this, 'mousemove', this.mouseMove);
  }
 }

 google.maps.Circle.prototype.mouseUp = function(event) {
  this.getMap().setOptions({draggable: true});
  google.maps.event.removeListener(this.handleMoveListener);
  this.handleMoveListener = null;
 }

 google.maps.Circle.prototype.mouseMove = function(event) {
  this.setCenter(event.latLng);
  var new_points = fencePoly.getPath();
  new_points.setAt(this.polyFenceIndex, event.latLng);
  fencePoly.setPath(new_points);
 }

 google.maps.Circle.prototype.mapIdle = function() {
  //resize the handle
  var map_bounds = this.getMap().getBounds();   
  var map_width = google.maps.geometry.spherical.computeDistanceBetween(map_bounds.getNorthEast(), map_bounds.getSouthWest());
  this.setRadius(map_width/80);
 }
