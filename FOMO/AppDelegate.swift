//
//  AppDelegate.swift
//  FOMO
//
//  Created by Edward Arenberg on 6/20/15.
//  Copyright (c) 2015 Hackathon. All rights reserved.
//

import UIKit
import Parse
import SenseSdk

class PoiCallback: RecipeFiredDelegate {
  
  @objc func recipeFired(args: RecipeFiredArgs) {
    
    NSLog("Recipe \(args.recipe.name) fired at \(args.timestamp). ")

    let trigger = args.recipe.trigger
    
    for triggerFired in args.triggersFired {
      for place in triggerFired.places {
        if place.type != .Poi {
          continue
        }
        let poiPlace = place as! PoiPlace
        
        switch (trigger.transitionType) {
        case .Enter:
            //Database.sharedDatabase.savePoiPlaceEntryEvent(poiPlace)
          Database.sharedDatabase.updatePoiPlaceEntryCount(poiPlace, is_entry: true)
        case .Exit:
            //Database.sharedDatabase.deletePoiPlaceEntryEvent(poiPlace)
          Database.sharedDatabase.updatePoiPlaceEntryCount(poiPlace, is_entry: false)
        }
        
        NSLog(place.description)
      }
    }
  }
  
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        Parse.setApplicationId("Dj5T3snXOZ4jrwifJLwxIMqZYzSsK7EJaEVtkQDi", clientKey: "QBuyosfx3NIRxGin0gHHcFuzqmKkJzYvtw4Z1NSf")
        
        SenseSdk.enableSdkWithKey("FOMO1234")
      
        Database.sharedDatabase
      PeopleSim.sharedPeopleSim
      PeopleSim.sharedPeopleSim.genPlaces()

        let poiTypes = [
          PoiType.Airport,
          PoiType.Bar,
          PoiType.Restaurant,
          PoiType.Mall,
          PoiType.Cafe,
          PoiType.Gym
      ]
      
      let oneHourCooldown = Cooldown.create(oncePer: 1, frequency: CooldownTimeUnit.Hours)!
      let poiCallback = PoiCallback()
      
      for poiType in poiTypes {
        let entryTrigger = FireTrigger.whenEntersPoi(poiType)!
        let exitTrigger = FireTrigger.whenExitsPoi(poiType)!

        let entryRecipe = Recipe(name: "Entry:\(poiType.description)", trigger: entryTrigger, timeWindow: TimeWindow.allDay, cooldown: oneHourCooldown)
        let exitRecipe = Recipe(name: "Exit:\(poiType.description)", trigger: exitTrigger, timeWindow: TimeWindow.allDay, cooldown: oneHourCooldown)

        SenseSdk.register(recipe: entryRecipe, delegate: poiCallback)
        SenseSdk.register(recipe: exitRecipe, delegate: poiCallback)

      }

      PeopleSim.sharedPeopleSim.startSim2()
      
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

