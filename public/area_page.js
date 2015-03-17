function app() {
  // If <= IE 9
  if (window.XDomainRequest) {
    loadScript("http://g5-widget-garden.herokuapp.com/javascripts/libs/jquery.xdomainrequest.min.js");
  }

  loadScript("//maps.googleapis.com/maps/api/js?sensor=false&callback=initialize");

  function loadScript(url) {
    var script = document.createElement("script");
    script.type = "text/javascript";
    script.src = url;

    $("body").append(script);
  }
};

function initialize() {
  setMapMarker = function(address, formattedAddress){
    $.getJSON("http://maps.googleapis.com/maps/api/geocode/json", {
      address: address,
      sensor: "false"
    }).done(function(data) {
      coordinates = data.results[0].geometry.location;
      var latlng = new google.maps.LatLng(coordinates.lat, coordinates.lng)
      var locationMarker = new google.maps.Marker({
        position: latlng,
        map: window.googleMaps.map,
        title: address
      });

      var infowindow = new google.maps.InfoWindow({
        content: formattedAddress
      });

      google.maps.event.addListener(locationMarker, 'click', function() {
        infowindow.open(window.googleMaps.map, locationMarker);
      });

      window.googleMaps.latlngbounds.extend(latlng);
      window.googleMaps.map.fitBounds(window.googleMaps.latlngbounds);
    });
  }

  window.googleMaps = {};
  window.googleMaps.latlngbounds = new google.maps.LatLngBounds();
  widgetMapConfig = JSON.parse($('.map .config:first').html());

  mapOptions = {
    scrollwheel: widgetMapConfig.panZoom,
    draggable: widgetMapConfig.panZoom,
    disableDefaultUI: !widgetMapConfig.panZoom,
    disableDoubleClickZoom: !widgetMapConfig.panZoom,
    zoom: 16,
    mapTypeId: google.maps.MapTypeId[widgetMapConfig.mapType]
  };

  window.googleMaps.map = new google.maps.Map($(".map .canvas")[0], mapOptions);

  for (var i=0; i < widgetMapConfig.addresses.length; i++){
    setMapMarker(widgetMapConfig.addresses[i][0], widgetMapConfig.addresses[i][1]);
  }
}

$(document).ready(app);
