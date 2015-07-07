//
//  Extensions.swift
//  FOMO
//
//  Created by Austin Mao on 6/20/15.
//  Copyright (c) 2015 Hackathon. All rights reserved.
//

import Foundation

extension NSDate {
  var formattedToISO8601: String {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
    formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
    formatter.calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierISO8601)!
    formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
    return formatter.stringFromDate(self)
  }
}