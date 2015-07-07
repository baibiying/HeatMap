//
//  EBEvent.swift
//  FOMO
//
//  Created by Edward Arenberg on 6/20/15.
//  Copyright (c) 2015 Hackathon. All rights reserved.
//

import Foundation

struct EBEvent {
  var ident : String
  var eventName : String
  var venueName: String
  var lat : Double
  var lon : Double
  var url : String
  
  init(j:JSON) {
    ident = j["id"].stringValue
    eventName = j["organizer"]["name"].stringValue
    venueName = j["venue"]["name"].stringValue
    url = j["url"].stringValue
    lat = j["venue"]["latitude"].doubleValue
    lon = j["venue"]["longitude"].doubleValue
  }
}
