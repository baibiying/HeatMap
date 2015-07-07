//
//  Event.swift
//  FOMO
//
//  Created by Edward Arenberg on 6/20/15.
//  Copyright (c) 2015 Hackathon. All rights reserved.
//

import Foundation
import SenseSdk

class Event {
  var ident : String
  var eventName : String
  var venueName: String
  var url : String
  var lat : Double
  var lon : Double
  var presentCheckIns: Int // new checkins - exits
  var recentCheckIns: Int // new checkins only
  var poiPlace: PoiPlace?
  
  init(j:JSON) {
    ident = j["id"].stringValue
    eventName = j["event"]["eventName"].stringValue
    venueName = j["venue"]["venueName"].stringValue
    url = j["url"].stringValue
    lat = j["venue"]["latitude"].doubleValue
    lon = j["venue"]["longitude"].doubleValue
    presentCheckIns = j["presentCheckIns"].intValue
    recentCheckIns = j["recentCheckIns"].intValue
  }
  init() {
    ident = ""
    eventName = ""
    venueName = ""
    url = ""
    lat = 0
    lon = 0
    presentCheckIns = 0
    recentCheckIns = 0
  }

  init(ident:String,eventName:String,venueName:String,url:String,lat:Double,lon:Double,presentCheckIns:Int,recentCheckIns:Int) {
    self.ident = ident
    self.eventName = eventName
    self.venueName = venueName
    self.url = url
    self.lat = lat
    self.lon = lon
    self.presentCheckIns = presentCheckIns
    self.recentCheckIns = recentCheckIns
  }
  
}

