//
//  Database.swift
//  FOMO
//
//  Created by Jeffrey Arenberg on 6/20/15.
//  Copyright (c) 2015 Hackathon. All rights reserved.
//

import UIKit
import MapKit
import SenseSdk
import Parse

let PARSE_CLASS = "FOMO_X"
let PARSE_CLASS2 = "FOMO_SUM"
let PARSE_CLASS3 = "FOMO"

@objc class Database {
    
  class var sharedDatabase : Database {
    struct Static {
      static let instance = Database()
    }
    return Static.instance
  }
  
  
  
  func savePoiPlaceEntryEvent(p: PoiPlace) {
    var event = PFObject(className:PARSE_CLASS)
//    event["uuid"] = Device.sharedInstance().UUID()
    event["uuid"] = PeopleSim.sharedPeopleSim.getCurrentPerson()

    
    event["typeId"] = p.types.first?.rawValue
    event["typeName"] = p.types.first?.description
    event["placeId"] = p.id
//    event["placeName"] = p.name
    event["point"] = PFGeoPoint(latitude:p.location.latitude, longitude:p.location.longitude)
    event.saveInBackgroundWithBlock {
      (success: Bool, error: NSError?) -> Void in
      if (success) {
        // The object has been saved.
        println("Saved")

      } else {
        // There was a problem, check error.description
        println("Error: \(error!) \(error!.userInfo!)")
      }
    }
    
  }

  // call this on exit
  func deletePoiPlaceEntryEvent(p: PoiPlace) {
    var query = PFQuery(className:PARSE_CLASS)
    query.whereKey("uuid", equalTo:PeopleSim.sharedPeopleSim.getCurrentPerson())
    query.whereKey("placeId", equalTo:p.id)
    query.findObjectsInBackgroundWithBlock {
      (objects: [AnyObject]?, error: NSError?) -> Void in
      
      if error == nil {
        // The find succeeded.
        println("Successfully retrieved \(objects!.count) events.")
        // Do something with the found objects
        if let objects = objects as? [PFObject] {
          for object in objects {
            object.deleteInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
              if (success) {
                println("Deleted: \(object.objectId)")
              }
              else {
                println("Error: \(error!) \(error!.userInfo!)")
              }
            })
          }
        }
      } else {
        // Log details of the failure
        println("Error: \(error!) \(error!.userInfo!)")
      }
    }
  }
  
  // TODO: define call back block after find
  func findEntryEvents(region: MKCoordinateRegion) {
    
    let sw = PFGeoPoint(
      latitude:region.center.latitude - (region.span.latitudeDelta  / 2.0),
      longitude:region.center.longitude - (region.span.longitudeDelta / 2.0)
    )
    let ne = PFGeoPoint(
      latitude:region.center.latitude + (region.span.latitudeDelta  / 2.0),
      longitude:region.center.longitude + (region.span.longitudeDelta / 2.0)
    )
    
    var query = PFQuery(className:PARSE_CLASS)
    query.whereKey("point", withinGeoBoxFromSouthwest:sw, toNortheast:ne)
    query.findObjectsInBackgroundWithBlock {
      (objects: [AnyObject]?, error: NSError?) -> Void in
      
      if error == nil {
        // The find succeeded.
        println("Successfully retrieved \(objects!.count) events.")
        // Do something with the found objects
        if let objects = objects as? [PFObject] {
          for object in objects {
              // return these in block
          }
        }
      } else {
        // Log details of the failure
        println("Error: \(error!) \(error!.userInfo!)")
      }
    }
  }
  
  
  func updatePoiPlaceEntryCount(p: PoiPlace, is_entry:Bool) {
    var query = PFQuery(className:PARSE_CLASS3)
    query.whereKey("placeId", equalTo:p.id)
    query.findObjectsInBackgroundWithBlock {
      (objects: [AnyObject]?, error: NSError?) -> Void in
      
      if error == nil {
        // The find succeeded.
        println("Successfully retrieved \(objects!.count) events.")
        if objects!.count > 0 {
          // Do something with the found objects
          if let objects = objects as? [PFObject] {
            for object in objects {
              if is_entry {
                object.incrementKey("presentCheckIns")
              }
              else {
                object.incrementKey("presentCheckIns", byAmount: -1)
              }
              object.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                if (success) {
                  println("Saved")
                }
                else {
                  println("Error: \(error!) \(error!.userInfo!)")
                }
              })
            }
          }
        }
      }
      else {
        // Log details of the failure
        println("Error: \(error!) \(error!.userInfo!)")
      }
    }
  }
  
  func findEntryCounts(region: MKCoordinateRegion) {
    
    let sw = PFGeoPoint(
      latitude:region.center.latitude - (region.span.latitudeDelta  / 2.0),
      longitude:region.center.longitude - (region.span.longitudeDelta / 2.0)
    )
    let ne = PFGeoPoint(
      latitude:region.center.latitude + (region.span.latitudeDelta  / 2.0),
      longitude:region.center.longitude + (region.span.longitudeDelta / 2.0)
    )
    
    var query = PFQuery(className:PARSE_CLASS3)
    query.whereKey("point", withinGeoBoxFromSouthwest:sw, toNortheast:ne)
    query.findObjectsInBackgroundWithBlock {
      (objects: [AnyObject]?, error: NSError?) -> Void in
      
      if error == nil {
        // The find succeeded.
        println("Successfully retrieved \(objects!.count) events.")
        // Do something with the found objects
        if let objects = objects as? [PFObject] {
          for object in objects {
            // return these in block
          }
        }
      } else {
        // Log details of the failure
        println("Error: \(error!) \(error!.userInfo!)")
      }
    }
  }
  

  /* run this once only */
  func saveEvent(e: Event) {
    var event = PFObject(className:PARSE_CLASS3)
    
    event["eventName"] = e.eventName
    event["venueName"] = e.venueName
    event["url"] = e.url
    event["point"] = PFGeoPoint(latitude:e.lat, longitude:e.lon)
    event["placeId"] = e.ident
    event["presentCheckIns"] = 0
    event.saveInBackgroundWithBlock {
      (success: Bool, error: NSError?) -> Void in
      if (success) {
        // The object has been saved.
        println("Saved")

      } else {
        // There was a problem, check error.description
        println("Error: \(error!) \(error!.userInfo!)")
      }
    }
    
  }
  
  func readEvents(callback:([Event])->()) {
    
    var query = PFQuery(className:PARSE_CLASS3)
    query.findObjectsInBackgroundWithBlock {
      (objects: [AnyObject]?, error: NSError?) -> Void in
      
      var events:[Event] = []
      if error == nil {
        // The find succeeded.
        println("Successfully retrieved \(objects!.count) events.")
        // Do something with the found objects
        if let objects = objects as? [PFObject] {
          for object in objects {
            let event:Event = Event(ident: object["placeId"] as! String, eventName: object["eventName"] as! String, venueName: object["venueName"] as! String, url: object["url"] as! String, lat: object["point"]!.latitude!, lon: object["point"]!.longitude!, presentCheckIns: object["presentCheckIns"] as! Int, recentCheckIns: 0)
            events.append(event)
          }
          callback(events)
        }
      } else {
        // Log details of the failure
        println("Error: \(error!) \(error!.userInfo!)")
      }
    }
    
  }
  
}
