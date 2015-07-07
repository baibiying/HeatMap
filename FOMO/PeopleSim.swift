//
//  PeopleSim.swift
//  FOMO
//
//  Created by Jeffrey Arenberg on 6/20/15.
//  Copyright (c) 2015 Hackathon. All rights reserved.
//

import Foundation
import SenseSdk

struct EntryEvent {
  var person : String
  var place : PoiPlace
}


class PeopleSim {
  
  class var sharedPeopleSim : PeopleSim {
    struct Static {
      static let instance = PeopleSim()
    }
    return Static.instance
  }
  
  var currentPerson:String = Device.sharedInstance().UUID()
  var places:[PoiPlace] = []
  var currentOffset = 0
  var events:[Event] = []
  var totalEntry = 0
  
  var simEntries:[EntryEvent] = []
  
  let minEvents = 300
  let offsetDrift:Double = 0.20
  
  let errorPointer = SenseSdkErrorPointer.create()
  
  func setRandomPerson() {
    currentPerson =  NSString.UUID()
  }
  
  func getCurrentPerson() -> String {
    return currentPerson
  }
  
  func genGaussRandom(m: Int, offset: Int) -> Int {
    var total:Double = 0
    for i in 1...10 {
      total += Double(arc4random_uniform(UInt32(m)))
    }
    let t = (Int(total * 0.1) + offset) % m
    return t
  }
  
  func genPlaces() {
    
    events.append(Event(ident: "17017048450", eventName: "PIFLabs", venueName: "Expert DOJO Patio, Unit 308, ", url: "http://www.eventbrite.com/e/biggest-best-monthly-networking-conference-in-la-tickets-17017048450?aff=ebapi", lat: 34.0139734, lon: -118.4944602, presentCheckIns: 0, recentCheckIns: 0))
    events.append(Event(ident: "16966089029", eventName: "Fernando Pullum Community Arts Center", venueName: "Fernando Pullum Community Art Center", url: "http://www.eventbrite.com/e/fernando-pullum-community-arts-center-motown-summer-arts-camp-tickets-16966089029?aff=ebapi", lat: 34.006151, lon: -118.331288, presentCheckIns: 0, recentCheckIns: 0))
    events.append(Event(ident: "17233318319", eventName: "The Perfect Exposure Gallery & über EDITIONS", venueName: "The Perfect Exposure Gallery", url: "http://www.eventbrite.com/e/the-rolling-stones-live-at-the-marquee-london-mar-1971-tickets-17233318319?aff=ebapi", lat: 34.063657, lon: -118.2985615, presentCheckIns: 0, recentCheckIns: 0))
    events.append(Event(ident: "17314576364", eventName: "#KickBackLA Presented by #Becks", venueName: "THE BAR", url: "http://www.eventbrite.com/e/the-kickback-la-sunday-june-21st-tickets-17314576364?aff=ebapi", lat: 34.0983573, lon: -118.3174352, presentCheckIns: 0, recentCheckIns: 0))
    events.append(Event(ident: "17326363620", eventName: "SMPTE Hollywood Section", venueName: "Linwood Dunn Theater", url: "http://www.eventbrite.com/e/smpte-evening-meeting-tickets-17326363620?aff=ebapi", lat: 34.094572, lon: -118.327091, presentCheckIns: 0, recentCheckIns: 0))
    events.append(Event(ident: "17009826850", eventName: "General Assembly ", venueName: "General Assembly ", url: "http://www.eventbrite.com/e/500-startups-roadshow-los-angeles-tickets-17009826850?aff=ebapi", lat: 34.0246352, lon: -118.4821571, presentCheckIns: 0, recentCheckIns: 0))
    events.append(Event(ident: "16950873519", eventName: "Athleta", venueName: "Grove", url: "http://www.eventbrite.com/e/athletathe-grove-summer-solstice-tickets-16950873519?aff=ebapi", lat: 34.071604, lon: -118.357937, presentCheckIns: 0, recentCheckIns: 0))
    events.append(Event(ident: "17267425334", eventName: "Dodger Parking", venueName: "Dodger Stadium Parking", url: "http://www.eventbrite.com/e/game-40-dodgers-vs-giants-registration-17267425334?aff=ebapi", lat: 34.0732204, lon: -118.2409737, presentCheckIns: 0, recentCheckIns: 0))
    events.append(Event(ident: "17228035518", eventName: "Women Founders Network", venueName: "DLA PIPER", url: "http://www.eventbrite.com/e/building-your-brand-how-to-get-it-right-the-first-time-tickets-17228035518?aff=ebapi", lat: 34.0571327, lon: -118.4148498, presentCheckIns: 0, recentCheckIns: 0))
    events.append(Event(ident: "17379651004", eventName: "Cristian David, Keller Williams Brentwood", venueName: "Skirball Cultural Center", url: "http://www.eventbrite.com/e/master-series-tickets-17379651004?aff=ebapi", lat: 34.0963058, lon: -118.4980744, presentCheckIns: 0, recentCheckIns: 0))
    events.append(Event(ident: "16848915560", eventName: "BeMyApp", venueName: "Maker City LA", url: "http://www.eventbrite.com/e/intel-edisontm-meetup-los-angeles-tickets-16848915560?aff=ebapi", lat: 34.03093, lon: -118.2666412, presentCheckIns: 0, recentCheckIns: 0))
    events.append(Event(ident: "17415386891", eventName: "Three Weavers and Pink Boots Society", venueName: "Three Weavers Brewing Company", url: "http://www.eventbrite.com/e/pink-boots-takeover-of-three-weavers-tickets-17415386891?aff=ebapi", lat: 33.9608211, lon: -118.3746139, presentCheckIns: 0, recentCheckIns: 0))
    events.append(Event(ident: "16504690975", eventName: "Jobvite", venueName: "JW Marriott Los Angeles L.A. Live", url: "http://www.eventbrite.com/e/talent-geeks-hosted-by-jobvite-is-coming-to-los-angeles-tickets-16504690975?aff=ebapi", lat: 34.0451645, lon: -118.2666085, presentCheckIns: 0, recentCheckIns: 0))
    events.append(Event(ident: "17085411927", eventName: "Beach=Culture at the Annenberg Community Beach House", venueName: "Annenberg Community Beach House", url: "http://www.eventbrite.com/e/dance-hall-square-dance-with-triple-chicken-foot-caller-susan-michaels-registration-17085411927?aff=ebapi", lat: 34.0243733, lon: -118.5122008, presentCheckIns: 0, recentCheckIns: 0))
    events.append(Event(ident: "17106452861", eventName: "General Assembly ", venueName: "General Assembly", url: "http://www.eventbrite.com/e/making-money-as-a-video-content-creator-tickets-17106452861?aff=ebapi", lat: 34.0128358, lon: -118.495338, presentCheckIns: 0, recentCheckIns: 0))
    events.append(Event(ident: "17325265335", eventName: "Ms. In The Biz ", venueName: "Arena Cinema", url: "http://www.eventbrite.com/e/msmoviemonday-w-mixer-hosted-by-arena-cinema-21-years-old-and-up-tickets-17325265335?aff=ebapi", lat: 34.100699, lon: -118.336301, presentCheckIns: 0, recentCheckIns: 0))
    events.append(Event(ident: "16823839557", eventName: "Cornerstone Church West LA", venueName: "Cornerstone Church West Los Angeles", url: "http://www.eventbrite.com/e/2015-vacation-bible-school-jesus-the-ultimate-superhero-registration-16823839557?aff=ebapi", lat: 34.041949, lon: -118.454894, presentCheckIns: 0, recentCheckIns: 0))
    events.append(Event(ident: "17314688700", eventName: "HIP HOP DX, URBN 24/7, LA HIPHOP EVENTS, DELICIOUS VINYL, HENGEE GARCIA", venueName: "THE BAR", url: "http://www.eventbrite.com/e/viny-la-june-21st-tickets-17314688700?aff=ebapi", lat: 34.0983573, lon: -118.3174352, presentCheckIns: 0, recentCheckIns: 0))
    events.append(Event(ident: "16745147186", eventName: "Live Talks Los Angeles", venueName: "The Ann and Jerry Moss Theater--New Roads School", url: "http://www.eventbrite.com/e/colin-quinn-in-conversation-with-tim-meadows-tickets-16745147186?aff=ebapi", lat: 34.0312888, lon: -118.461258, presentCheckIns: 0, recentCheckIns: 0))
    events.append(Event(ident: "17068393023", eventName: "The Ivy Plus Society", venueName: "Bar Marmont", url: "http://www.eventbrite.com/e/la-summer-nights-62215-tickets-17068393023?aff=ebapi", lat: 34.09819, lon: -118.367368, presentCheckIns: 0, recentCheckIns: 0))
    events.append(Event(ident: "17148120490", eventName: "AMA Los Angeles", venueName: "Pearl's Liquor Bar", url: "http://www.eventbrite.com/e/libations-at-pearls-liquor-bar-tickets-17148120490?aff=ebapi", lat: 34.0908487, lon: -118.3858214, presentCheckIns: 0, recentCheckIns: 0))
    events.append(Event(ident: "16018741487", eventName: "LA Senior Hunger Summit Committee", venueName: "The California Endowment", url: "http://www.eventbrite.com/e/la-senior-hunger-summit-tickets-16018741487?aff=ebapi", lat: 34.059466, lon: -118.235907, presentCheckIns: 0, recentCheckIns: 0))
    events.append(Event(ident: "17358995222", eventName: "", venueName: "East West Players", url: "http://www.eventbrite.com/e/awesome-asian-bad-guys-special-screening-celebration-tickets-17358995222?aff=ebapi", lat: 34.0506318, lon: -118.2399438, presentCheckIns: 0, recentCheckIns: 0))
    events.append(Event(ident: "17034904859", eventName: "The Thrive Tribe", venueName: "Mark Goldberg's Home", url: "http://www.eventbrite.com/e/wet-and-wild-fundraiser-pool-party-tickets-17034904859?aff=ebapi", lat: 34.086015, lon: -118.367268, presentCheckIns: 0, recentCheckIns: 0))
    events.append(Event(ident: "17383076249", eventName: "Mike Uryga", venueName: "Hollywood Improv", url: "http://www.eventbrite.com/e/shining-some-laughs-on-junes-gloom-free-tix-tickets-17383076249?aff=ebapi", lat: 34.0835766, lon: -118.3674155, presentCheckIns: 0, recentCheckIns: 0))
    events.append(Event(ident: "17090502152", eventName: "Mid City West Community Council", venueName: "Open Space Theatre & Cafe", url: "http://www.eventbrite.com/e/urbanism-solstice-mixer-tickets-17090502152?aff=ebapi", lat: 34.0798375, lon: -118.3614654, presentCheckIns: 0, recentCheckIns: 0))
    events.append(Event(ident: "16967920507", eventName: "Dani Kinkade", venueName: "Venice", url: "http://www.eventbrite.com/e/launch-party-tickets-16967920507?aff=ebapi", lat: 34.0415515, lon: -118.2791774, presentCheckIns: 0, recentCheckIns: 0))
    events.append(Event(ident: "16915542844", eventName: "Doctors Without Borders", venueName: "Santa Monica Public Library", url: "http://www.eventbrite.com/e/put-your-ideals-into-practice-doctors-without-borders-info-session-santa-monica-registration-16915542844?aff=ebapi", lat: 34.0185305, lon: -118.4933592, presentCheckIns: 0, recentCheckIns: 0))
    events.append(Event(ident: "16763697671", eventName: "Joanne Ameya Cohen & Achintya Devi", venueName: "Topanga State Beach", url: "http://www.eventbrite.com/e/wild-sacred-summer-solstice-womens-gathering-tickets-16763697671?aff=ebapi", lat: 34.0522342, lon: -118.2436849, presentCheckIns: 0, recentCheckIns: 0))
    events.append(Event(ident: "17329156975", eventName: "dpHUE, Clothes & Cocktails, Seacret, Sugar Rush by iisha, Svedka Vodka ", venueName: "dpHUE", url: "http://www.eventbrite.com/e/pamper-you-pop-up-tickets-17329156975?aff=ebapi", lat: 34.1427486, lon: -118.4016833, presentCheckIns: 0, recentCheckIns: 0))
    events.append(Event(ident: "17178945689", eventName: "Michael Coulombe", venueName: "Atwater Village Tavern", url: "http://www.eventbrite.com/e/east-side-indie-filmmaker-june-mixer-tickets-17178945689?aff=ebapi", lat: 34.117865, lon: -118.260469, presentCheckIns: 0, recentCheckIns: 0))
    events.append(Event(ident: "17267793435", eventName: "hosted by Diane Crumley and Diane Levy, a Diane-squared event", venueName: "The E Spot Lounge", url: "http://www.eventbrite.com/e/circa-75-summer-solstice-jam-and-hang-tickets-17267793435?aff=ebapi", lat: 34.1395597, lon: -118.3870991, presentCheckIns: 0, recentCheckIns: 0))
    events.append(Event(ident: "17366519728", eventName: "Los Angeles Digital Imaging Group", venueName: "Plummer Park Community Center", url: "http://www.eventbrite.com/e/whats-new-with-adobe-lightroom-tickets-17366519728?aff=ebapi", lat: 34.093362, lon: -118.351185, presentCheckIns: 0, recentCheckIns: 0))
    events.append(Event(ident: "17407702908", eventName: "Sounds Like", venueName: "Sounds Like Summer Terrace", url: "http://www.eventbrite.com/e/sounds-like-summer-terrace-with-human-resources-enzo-muro-divine-minds-in-time-tickets-17407702908?aff=ebapi", lat: 34.1011114, lon: -118.3281776, presentCheckIns: 0, recentCheckIns: 0))
    events.append(Event(ident: "16159413240", eventName: "First Baptist Church of Venice, Apostle Michelle Allen & Bishop Horace Allen", venueName: "FIRST BAPTIST CHURCH OF VENICE WORSHIP CENTER", url: "http://www.eventbrite.com/e/fire-in-the-whole-revival-conference-registration-16159413240?aff=ebapi", lat: 33.9954981, lon: -118.4652233, presentCheckIns: 0, recentCheckIns: 0))
    events.append(Event(ident: "17191441063", eventName: "SMCLA", venueName: "General Assembly ", url: "http://www.eventbrite.com/e/instapets-the-rise-of-the-animal-celebrity-tickets-17191441063?aff=ebapi", lat: 34.0295114, lon: -118.2848199, presentCheckIns: 0, recentCheckIns: 0))
    events.append(Event(ident: "16975216329", eventName: "Angel City Derby Girls", venueName: "ACDG HQ", url: "http://www.eventbrite.com/e/4th-annual-camp-scarlet-tickets-16975216329?aff=ebapi", lat: 33.9055609, lon: -118.3032275, presentCheckIns: 0, recentCheckIns: 0))
    events.append(Event(ident: "17281581676", eventName: "SOULNOVA", venueName: "King King", url: "http://www.eventbrite.com/e/soulnova-afterworld-wdoc-martin-ron-d-core-tickets-17281581676?aff=ebapi", lat: 34.101822, lon: -118.333013, presentCheckIns: 0, recentCheckIns: 0))
    events.append(Event(ident: "17446177988", eventName: "Breaking Band", venueName: "YouTube Spaces", url: "http://www.eventbrite.com/e/andie-case-live-at-youtube-space-la-featuring-surprise-rock-legend-host-tickets-17446177988?aff=ebapi", lat: 33.976817, lon: -118.407265, presentCheckIns: 0, recentCheckIns: 0))
    events.append(Event(ident: "14929551691", eventName: "Jeanine Jacobson", venueName: "Sheppard Mullin", url: "http://www.eventbrite.com/e/how-to-start-up-in-la-tickets-14929551691?aff=ebapi", lat: 34.0595724, lon: -118.4176199, presentCheckIns: 0, recentCheckIns: 0))
    events.append(Event(ident: "17127756581", eventName: "Angel City Brewery", venueName: "Angel City Brewery", url: "http://www.eventbrite.com/e/ale-academy-xii-beer-and-cheese-pairing-tickets-17127756581?aff=ebapi", lat: 34.0463, lon: -118.237677, presentCheckIns: 0, recentCheckIns: 0))
    events.append(Event(ident: "17175287748", eventName: "CA Realty Training", venueName: "Keller Williams Marina/LA", url: "http://www.eventbrite.com/e/real-estate-career-night-event-marina-del-rey-tickets-17175287748?aff=ebapi", lat: 33.9842671, lon: -118.4487835, presentCheckIns: 0, recentCheckIns: 0))
    events.append(Event(ident: "2355417116", eventName: "Joyce Schwarz, Best-selling Author, THE VISION BOARD book as seen on E Entertainment TV and on BEYOND THE SECRET DVD. Jack Canfield says, 'This book will change your life' www.visionboard.info", venueName: "Via Home Study from Vision Board Institute", url: "http://www.eventbrite.com/e/home-study-be-a-certified-vision-board-coach-from-anywhere-in-world-tickets-2355417116?aff=ebapi", lat: 33.9839045, lon: -118.4588511, presentCheckIns: 0, recentCheckIns: 0))
    events.append(Event(ident: "17164872596", eventName: "Pono Burger", venueName: "Pono Burger", url: "http://www.eventbrite.com/e/burger-beer-dinner-party-with-chef-makani-strand-brewing-co-tickets-17164872596?aff=ebapi", lat: 34.018986, lon: -118.489267, presentCheckIns: 0, recentCheckIns: 0))
    events.append(Event(ident: "16963268593", eventName: "DUFF'S CAKEMIX", venueName: "Duff's Cakemix", url: "http://www.eventbrite.com/e/fathers-day-cupcake-event-tickets-16963268593?aff=ebapi", lat: 34.0931603, lon: -118.3783347, presentCheckIns: 0, recentCheckIns: 0))
    events.append(Event(ident: "17132063463", eventName: "Line 6 Events", venueName: "Guitar Center", url: "http://www.eventbrite.com/e/tone-made-easy-guitars-guitar-center-sherman-oaks-registration-17132063463?aff=ebapi", lat: 34.150141, lon: -118.442324, presentCheckIns: 0, recentCheckIns: 0))
    events.append(Event(ident: "17395229600", eventName: "Studio Director: Jo-Ann / Annie Grindlay Studio ", venueName: "Annie Grindlay Studio,", url: "http://www.eventbrite.com/e/june-22nd-annie-grindlay-studio-free-workshop-bring-headshot-resume-tickets-17395229600?aff=ebapi", lat: 34.0761443, lon: -118.3526494, presentCheckIns: 0, recentCheckIns: 0))
    events.append(Event(ident: "17464448636", eventName: "Dapster - Haircuts at Your Convenience", venueName: "", url: "http://www.eventbrite.com/e/dapster-meet-greet-haircuts-at-your-convenience-tickets-17464448636?aff=ebapi", lat: 34.0399101, lon: -118.2672368, presentCheckIns: 0, recentCheckIns: 0))
    events.append(Event(ident: "17236540958", eventName: "Cathleene Cienfuegos and Macaya Miracle", venueName: "", url: "http://www.eventbrite.com/e/accelerated-light-healing-events-in-la-tickets-17236540958?aff=ebapi", lat: 33.9850469, lon: -118.4694832, presentCheckIns: 0, recentCheckIns: 0))
    events.append(Event(ident: "17175193466", eventName: "CA Realty Training", venueName: "Keller Williams- Westside LA", url: "http://www.eventbrite.com/e/real-estate-career-night-event-westwood-tickets-17175193466?aff=ebapi", lat: 34.0587454, lon: -118.4429834, presentCheckIns: 0, recentCheckIns: 0))
    
    for event in events {
      let poiPlace = PoiPlace(latitude: event.lat, longitude: event.lon, radius: 50, name: event.venueName, id: event.ident, types: [.Restaurant])
      places.append(poiPlace)
      event.poiPlace = poiPlace
      
      /* run this once */
      //Database.sharedDatabase.saveEvent(event)
    }

  }
  
  func getRandomPlace() -> PoiPlace {
    let i = genGaussRandom(places.count, offset: currentOffset)
    NSLog("Random: \(i) \(currentOffset)")
    return places[Int(i)]
  }
  
  func simEntry() {
    
    let place = getRandomPlace()
    //setRandomPerson()
    
    SenseSdkTestUtility.fireTrigger(
      fromRecipe: "Entry:Restaurant",
      confidenceLevel: ConfidenceLevel.Medium,
      places: [place],
      errorPtr: errorPointer
    )
    
    if errorPointer.error != nil {
      NSLog("Error sending trigger")
    }
    
    let event = EntryEvent(person: currentPerson, place:place)
    simEntries.append(event)
  }
  
  
  func simExit() {
    if simEntries.count < minEvents {
      return
    }
    
    let i = arc4random_uniform(UInt32(simEntries.count))
    
    let event = simEntries[Int(i)]
    currentPerson = event.person
   
    SenseSdkTestUtility.fireTrigger(
      fromRecipe: "Exit:Restaurant",
      confidenceLevel: ConfidenceLevel.Medium,
      places: [event.place],
      errorPtr: errorPointer
    )
    
    if errorPointer.error != nil {
      NSLog("Error sending trigger")
    }
    
    simEntries.removeAtIndex(Int(i))

  }
  
  func startSim() {
    let priority = DISPATCH_QUEUE_PRIORITY_BACKGROUND
    dispatch_async(dispatch_get_global_queue(priority, 0)) {
      var simCount:Int = 0
      while true {
        self.simEntry()
        self.simExit()
        sleep(1)
        simCount++
        self.currentOffset = Int(Double(simCount) * self.offsetDrift)
      }
    }
  }
  
  
  func getRandomEvent() -> Event {
    let i = genGaussRandom(places.count, offset: currentOffset)
    NSLog("Random: \(i) \(currentOffset)")
    return events[Int(i)]
  }
  
  func simEntry2() {
    
    let event = getRandomEvent()
    let place = event.poiPlace!
    
    SenseSdkTestUtility.fireTrigger(
      fromRecipe: "Entry:Restaurant",
      confidenceLevel: ConfidenceLevel.Medium,
      places: [place],
      errorPtr: errorPointer
    )
    event.presentCheckIns += 1
    totalEntry += 1
    
    if errorPointer.error != nil {
      NSLog("Error sending trigger")
    }
  }
  
  
  func simExit2() {
    if totalEntry < minEvents {
      return
    }
    
    let i = arc4random_uniform(UInt32(events.count))
    
    let event = events[Int(i)]
    if event.presentCheckIns <= 0 {
      return
    }
    println("present checkins: \(event.presentCheckIns)")
    let place = event.poiPlace!
    
    SenseSdkTestUtility.fireTrigger(
      fromRecipe: "Exit:Restaurant",
      confidenceLevel: ConfidenceLevel.Medium,
      places: [place],
      errorPtr: errorPointer
    )
    event.presentCheckIns -= 1
    totalEntry -= 1
    
    if errorPointer.error != nil {
      NSLog("Error sending trigger")
    }
    
  }
  
  
  func startSim2() {
    
    Database.sharedDatabase.readEvents() { events in
      self.totalEntry = 0
      for e in events {
        for ev in self.events {
          if e.ident == ev.ident {
            ev.presentCheckIns = e.presentCheckIns
            break
          }
        }
        self.totalEntry += e.presentCheckIns
      }
      
      let priority = DISPATCH_QUEUE_PRIORITY_BACKGROUND
      dispatch_async(dispatch_get_global_queue(priority, 0)) {
        var simCount:Int = 0
        while true {
          self.simEntry2()
          self.simExit2()
          sleep(1)
          simCount++
          self.currentOffset = Int(Double(simCount) * self.offsetDrift)
        }
      }
    }
  }
  
  
  
}