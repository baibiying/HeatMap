//
//  ViewController.swift
//  FOMO
//
//  Created by Edward Arenberg on 6/20/15.
//  Copyright (c) 2015 Hackathon. All rights reserved.
//

import UIKit
import MapKit
import SenseSdk
import LFHeatMap


class HeatMapOverlay: NSObject, MKOverlay {
  var coordinate: CLLocationCoordinate2D
  var boundingMapRect: MKMapRect
  
  init(map:MKMapView) {
    boundingMapRect = map.visibleMapRect
    coordinate = map.centerCoordinate
  }
}

class HeatOverRenderer : MKOverlayRenderer {
  var heatImage : UIImage?
  var isReady = false
  
  init(overlay:MKOverlay, image:UIImage) {
    heatImage = image
    super.init(overlay:overlay)
  }
  
  override func drawMapRect(mapRect: MKMapRect, zoomScale: MKZoomScale, inContext context: CGContext!) {
    let theMap = overlay.boundingMapRect
    let rect = rectForMapRect(theMap)
    
    CGContextAddRect(context, rectForMapRect(mapRect))
    CGContextClip(context)
    CGContextSetAlpha(context, 0.5)
    CGContextScaleCTM(context, 1.0, -1.0)
    CGContextTranslateCTM(context, 0.0, -rect.size.height)
    CGContextDrawImage(context, rect, heatImage?.CGImage)
    
  }
  override func canDrawMapRect(mapRect: MKMapRect, zoomScale: MKZoomScale) -> Bool {
    return isReady
  }
}


class ColorPin : MKPointAnnotation {
  var image : UIImage?
  var event : Event!
}

class CalloutButton : UIButton {
  var pin : ColorPin?
}

class MapPin : NSObject, MKAnnotation {
  var coordinate: CLLocationCoordinate2D
  var title: String
  var subtitle: String
  
  init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
    self.coordinate = coordinate
    self.title = title
    self.subtitle = subtitle
  }
}

//------------------before this not done-----------------------------

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

  var locationManager : CLLocationManager!
  var myLocation : CLLocation?
  var heatMapImage : UIImage?
  var heatOverlay : HeatMapOverlay?
  var heatRenderer : HeatOverRenderer?
  var events : [Event]?
  var fetching = false
  var timer : NSTimer?

  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var friendSwitch: UISwitch!
  @IBAction func friendChanged(sender: UISwitch) {
    regenHeatMap()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    locationManager = CLLocationManager()
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    locationManager.activityType = CLActivityType.Other
    
    if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedWhenInUse) {
      locationManager.requestWhenInUseAuthorization()
    } else {
      locationManager.startUpdatingLocation()
      mapView.showsUserLocation = true
    }

  }
  
  func timerFired(timer:NSTimer) {
    regenHeatMap()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBarHidden = true
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: -
  
  func addPin(event : Event) {
    let lat = event.lat
    let lon = event.lon
    let loc = CLLocationCoordinate2DMake(lat, lon)
    //                            dump(loc)
    // Drop a pin
    let dropPin = ColorPin()
    dropPin.event = event
    dropPin.coordinate = loc
    dropPin.title = event.eventName
    dropPin.subtitle = event.venueName
    dispatch_async(dispatch_get_main_queue()) {
      self.mapView.addAnnotation(dropPin)
    }
  }
  
  func getData() {
    if !fetching {
      fetching = true
//      spinner.startAnimating()
      mapView.removeAnnotations(mapView.annotations)
      dump(mapView.region)
      let center = mapView.region.center
      let deltaLat = mapView.region.span.latitudeDelta / 2
      let deltaLon = mapView.region.span.longitudeDelta / 2
      let neLat = center.latitude + deltaLat
      let neLon = center.longitude + deltaLon
      let swLat = center.latitude - deltaLat
      let swLon = center.longitude - deltaLon
      
      
      Database.sharedDatabase.readEvents() { events in
        self.events = events
        for e in events {
          self.addPin(e)
        }
        self.genHeatMap()
        self.fetching = false
        
        if self.timer == nil {
          self.timer = NSTimer(timeInterval: 5, target: self, selector: "timerFired:", userInfo: nil, repeats: true)
          NSRunLoop.mainRunLoop().addTimer(self.timer!, forMode: NSRunLoopCommonModes)
        }

      }
      
    }
  }
  
  func regenHeatMap() {
    Database.sharedDatabase.readEvents() { events in
      self.events = events
      self.mapView.removeOverlay(self.heatOverlay)
      self.heatOverlay = nil
      self.heatRenderer = nil
      self.genHeatMap()
      
      for ann in self.mapView.annotations as! [MKAnnotation] {
        if let av = self.mapView.viewForAnnotation(ann) as? MKPinAnnotationView, pin = ann as? ColorPin {
          if let event = pin.event {
            for e in self.events! {
              if e.ident == event.ident {
                event.presentCheckIns = e.presentCheckIns
                break
              }
            }
            if event.presentCheckIns > 20 {
              av.pinColor = .Red
            } else if event.presentCheckIns > 10 {
              av.pinColor = .Purple
            } else {
              av.pinColor = .Green
            }
            var label : UILabel!
            if let l = av.viewWithTag(99) as? UILabel {
              label = l
            } else {
              label = UILabel(frame: CGRectMake(-8, -4, 30, 19))
              label.tag = 99
              label.textAlignment = .Center
              label.textColor = UIColor(white: 0, alpha: 0.4)
              av.addSubview(label)
            }
            label.text = "\(event.presentCheckIns)"
          }
          av.setNeedsDisplay()
        }
      }
    }
  }
  
  func genHeatMap() {
    var locs = [CLLocation]()
    var weights = [Int]()
    var idx = 0
    for e in events! {
      if friendSwitch.on && idx++ > events!.count / 4 {
//      if friendSwitch.on && arc4random_uniform(4) == 0 {
//        continue
        break
      }
      locs.append(CLLocation(latitude: e.lat, longitude: e.lon))
      weights.append(e.presentCheckIns)
    }
    let hm = LFHeatMap.heatMapForMapView(self.mapView, boost: 1.0, locations: locs, weights: weights)
    self.heatMapImage = hm
    if heatRenderer == nil {
      let tile = HeatMapOverlay(map: self.mapView)
      heatOverlay = tile
      dispatch_async(dispatch_get_main_queue()) {
        //      tile.canReplaceMapContent = false
        self.mapView.addOverlay(tile, level: .AboveLabels)
      }
    } else {
      heatRenderer!.heatImage = self.heatMapImage
      heatRenderer?.setNeedsDisplayInMapRect(MKMapRectWorld)
      mapView.setNeedsDisplay()
    }

  }

//---------------------------below not done----------------------------------
  func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
//    let img = UIImage(named: "festival")
    if heatRenderer == nil {
      let tr = HeatOverRenderer(overlay: overlay, image: heatMapImage!)
      heatRenderer = tr
      tr.isReady = heatMapImage != nil
    }
    return heatRenderer
  }
  
  
  func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
    if (annotation is MKUserLocation) {
      //if annotation is not an MKPointAnnotation (eg. MKUserLocation),
      //return nil so map draws default view for it (eg. blue dot)...
      return nil
    }
    
    let reuseId = "MapPin"
    
    var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
    if anView == nil {
      anView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
      anView!.canShowCallout = true
    }
    else {
      //we are re-using a view, update its annotation reference...
      anView!.annotation = annotation
    }
    if let pin = annotation as? ColorPin {
      if let event = pin.event {
        if event.presentCheckIns > 20 {
          anView!.pinColor = .Red
        } else if event.presentCheckIns > 10 {
          anView!.pinColor = .Purple
        } else {
          anView!.pinColor = .Green
        }
        var label : UILabel!
        if let l = anView?.viewWithTag(99) as? UILabel {
          label = l
        } else {
          label = UILabel(frame: CGRectMake(-8, -4, 30, 19))
          label.tag = 99
          label.textAlignment = .Center
          label.textColor = UIColor(white: 0, alpha: 0.4)
          label.alpha = 0
          anView?.addSubview(label)
        }
        label.text = "\(event.presentCheckIns)"
      }
      if let img = pin.image {
        let iv = UIImageView(image: img)
        iv.frame = CGRectMake(0, 0, 32, 32)
        anView!.leftCalloutAccessoryView = iv
      }
      let b = CalloutButton.buttonWithType(.DetailDisclosure) as! CalloutButton
      b.pin = pin
      b.addTarget(self, action: "pinDetailHit:", forControlEvents: .TouchUpInside)
      anView!.rightCalloutAccessoryView = b
    }
    
    
    return anView
  }
  
  func pinDetailHit(button:CalloutButton) {
    if let event = button.pin?.event {
      
      if let vc = storyboard?.instantiateViewControllerWithIdentifier("WebVC") as? WebVC {
        vc.event = event
        navigationController?.pushViewController(vc, animated: true)

      }
      
    }
  }
  

  
  // MARK: -

  func mapView(mapView: MKMapView!, regionDidChangeAnimated animated: Bool) {

    if heatRenderer != nil {
      mapView.removeOverlay(heatOverlay)
      heatOverlay = nil
      heatRenderer = nil
//      heatOverlay?.coordinate = mapView.centerCoordinate
//      heatOverlay?.boundingMapRect = mapView.visibleMapRect
      genHeatMap()
    }
  }

  
  func mapViewDidFinishLoadingMap(mapView: MKMapView!) {
    getData()
  }

  
  // MARK: -
  
  func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    if status == CLAuthorizationStatus.AuthorizedAlways || status == CLAuthorizationStatus.AuthorizedWhenInUse {
      println("Authorized")
      locationManager.startUpdatingLocation()
      mapView.showsUserLocation = true
      mapView.region = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, 15000, 15000)
    }
  }
  
  func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
    //        println("Did Update Location")
    let loc = locations.last as? CLLocation
    if myLocation == nil {
      mapView.region = MKCoordinateRegionMakeWithDistance(loc!.coordinate, 15000, 15000)
    }
    myLocation = loc
  }
  
  func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
    println(error)
  }
  

}

