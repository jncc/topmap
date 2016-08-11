#''
angular.module 'topmap.test'
  .controller 'testCtrl', () ->
    testc = this
    
    wkt = 'POLYGON((-11.25 47.226532133867295,-11.25 49.274495136709376,-6.767578125 49.274495136709376,-6.767578125 47.226532133867295,-11.25 47.226532133867295))'
    coords = wkt.replace('POLYGON((','').replace('))','')
    latlngs = coords.split(',').map( (str) ->
      latlng = str.split(' ')
      {
        lng: latlng[0]
        lat: latlng[1]
      }
    )

    console.log(latlngs.length)

    #console.log(latlngs)
    console.log(latlngs[0].lng + ',' + latlngs[0].lat + ',' + latlngs[2].lng + ',' + latlngs[2].lat)

    #console.log(wkt.substring(0,7))
    
    return

