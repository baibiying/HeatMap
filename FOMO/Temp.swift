//
//  Temp.swift
//  FOMO
//
//  Created by Edward Arenberg on 6/20/15.
//  Copyright (c) 2015 Hackathon. All rights reserved.
//

import UIKit

/*
class Temp: NSObject {
  func temp() {
    let u = "http://opendsd.sandiego.gov/api/cecasemapsearch/?northeastlatitude=\(neLat)&northeastlongitude=\(neLon)&southwestlatitude=\(swLat)&southwestlongitude=\(swLon)"
    println(u)
    
    //            let df = NSDateFormatter()
    //            df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    var config = NSURLSessionConfiguration.defaultSessionConfiguration()
    config.HTTPAdditionalHeaders = ["Accept":"application/json"]
    let session = NSURLSession(configuration: config)
    if let url = NSURL(string: u) {
      let request = NSMutableURLRequest(URL: url)
      request.timeoutInterval = 20.0
      //                request.addValue("application/json", forHTTPHeaderField: "Accept")
      let task = session.dataTaskWithRequest(request, completionHandler: {(data,response,error) in
        println("Got Data = \(data.length) : \(error)")
        if error != nil {
          dispatch_async(dispatch_get_main_queue()) {
            UIAlertView(title: "Error Retrieving Data", message: error!.localizedDescription, delegate: nil, cancelButtonTitle: "OK").show()
            self.spinner.stopAnimating()
          }
          self.fetching = false
          return
        }
        let str = NSString(data: data, encoding: NSUTF8StringEncoding)
        //                    println(str)
        let res = response as! NSHTTPURLResponse
        if error == nil && res.statusCode == 200 {
          var error : NSError?
          /*
          if let json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &error) as? NSArray {
          dump(json)
          }
          */
          let json = JSON(data: data)
          println(json[0])
          for (index: String, subJson: SwiftyJSON.JSON) in json {
            let aCase = CECase(j: subJson)
            self.allCases.append(aCase)
          }
          self.adjustPins()
          self.fetching = false
          dispatch_async(dispatch_get_main_queue()) {
            self.spinner.stopAnimating()
            self.hMapButton.hidden = self.wideView
          }
          
        } else {
          self.fetching = false
          dispatch_async(dispatch_get_main_queue()) {
            self.spinner.stopAnimating()
          }
        }
      })
      task.resume()
      
    } else {
      self.spinner.stopAnimating()
    }

  }
}
*/
