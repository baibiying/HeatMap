//
//  EventBrite.swift
//  FOMO
//
//  Created by Austin Mao on 6/20/15.
//  Copyright (c) 2015 Hackathon. All rights reserved.
//

import Foundation
import UIKit

enum CheckInFilterType {
  case presentCheckIns
  case recentCheckIns
}

class EventBrite {
  var location: (lat: Float, long: Float) = (lat: 100, long: 100) // location to query for
  var distance = 10
  var unit = "mi"
  var startTime = ""
  var endTime = ""
  var filterPopular = true
  
  // construct GET url to get nearby events from eventbrite
  private func createEBNearbyEventsUrl(
    near location: (lat: Float, long: Float)!,
    within distance: Int,
    of distanceUnit: String,
    starting timeStart: String,
    ending timeEnd: String,
    shouldShowPopularOnly: Bool
  ) -> NSURL? {
    let url = NSURL(string: "https://www.eventbriteapi.com/v3/events/search/"
      + "?token=MTOOWPAPWPKSWYJKI7YT"
      + "&location.latitude=\(location.lat)"
      + "&location.longitude=\(location.long)"
      + "&location.within=\(distance)\(distanceUnit)"
      + "&start_date.range_start=\(timeStart)"
      + "&start_date.range_end=\(timeEnd)"
      + "&popular=\(shouldShowPopularOnly)"
    )
    println("EBNearbyEventsUrl is \(url)")
    return url
  }
  
  func getNearbyEvents(callback:([Event])->()) {
    // config session to accept json back
    let config = NSURLSessionConfiguration.defaultSessionConfiguration()
    config.HTTPAdditionalHeaders = ["Accept":"application/json"]
    let session = NSURLSession(configuration: config)
      
    // construct url
    if let url = createEBNearbyEventsUrl(
      near: location,
      within: distance,
      of: unit,
      starting: startTime,
      ending: endTime,
      shouldShowPopularOnly: filterPopular
    ) {
      let request = NSMutableURLRequest(URL: url)
      // set 20s timeout for GETting data back
      request.timeoutInterval = 20.0
      
      // specify task to open session with completion handler
      let task = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
        println("Got Data = \(data.length) : \(error)")
        
        // if error, alert error in main thread
        if error != nil {
          dispatch_async(dispatch_get_main_queue()) {
            UIAlertView(title: "Error Retrieving Data", message: error!.localizedDescription, delegate: nil, cancelButtonTitle: "OK").show()
//            self.spinner.stopAnimating()
          }
//          self.fetching = false
          return
        }
        
        // make string of return data
        let str = NSString(data: data, encoding: NSUTF8StringEncoding)
        let res = response as! NSHTTPURLResponse
//        println("data is \(str)")
        
        // if resp data, then convert to JSON
        if error == nil && res.statusCode == 200 {
          // JSON the data
          let json: JSON = JSON(data: data)
          let eventsArr = json["events"]
//          println(json)
          
          // for loop and create Event from json
          var events = [Event]()
          for (index: String, subJson: JSON) in eventsArr {
            let e = EBEvent(j:subJson)

//            let ev = Event(ident: e.ident, eventName: e.eventName, venueName: e.venueName, url: e.url, lat: e.lat, lon: e.lon, presentCheckIns: 0, recentCheckIns: 0)
            let str = "Event(ident: \"\(e.ident)\", eventName: \"\(e.eventName)\", venueName: \"\(e.venueName)\", url: \"\(e.url)\", lat: \(e.lat), lon: \(e.lon), presentCheckIns: 0, recentCheckIns: 0)"
            println(str)

            var event = Event()
            event.url = e.url
            event.lat = e.lat
            event.lon = e.lon
            event.venueName = e.venueName
            event.presentCheckIns = 0
            event.recentCheckIns = 0
            events.append(event)
          }
          // return events
          callback(events)
          
          // TODO: add pins method
//          self.adjustPins()
//          self.fetching = false
          
          // in main thread, stop animating spinner
          dispatch_async(dispatch_get_main_queue()) {
//            self.spinner.stopAnimating()
  //          self.hMapButton.hidden = self.wideView
          }
        } else {
//          self.fetching = false
          dispatch_async(dispatch_get_main_queue()) {
//            self.spinner.stopAnimating()
          } // dispatch_async
        } // else
      }) // let
      
      // execute task
      task.resume()
    } else {
//      self.spinner.stopAnimating()
    } // else
  } // func getNearbyEvents
  
  // draw a rect around event and then count users that are at that event
  // then filter based on params expressing thresholds of THE HOTNESS
  func filterEvents(events: [Event], by filter: CheckInFilterType) -> [Event] {
    var filteredEvents = [Event]()
    var minPresentPeople = 100
    
    for e in events {
      var filterCnt: Int
      
      switch filter {
      case .presentCheckIns: filterCnt = e.presentCheckIns
      case .recentCheckIns: filterCnt = e.recentCheckIns
      }
      
      if filterCnt >= minPresentPeople { filteredEvents.append(e) }
    } // for
    
    return filteredEvents
  } // func filterEvents
} // class
