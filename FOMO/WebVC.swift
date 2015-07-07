//
//  WebVC.swift
//  FOMO
//
//  Created by Edward Arenberg on 6/20/15.
//  Copyright (c) 2015 Hackathon. All rights reserved.
//

import UIKit

class WebVC: UIViewController, UIWebViewDelegate {

  var event : Event?

  @IBOutlet weak var webView: UIWebView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    if let e = event {
      title = "Heat: \(e.presentCheckIns)"
    }
    if let u = event?.url, nu = NSURL(string: event!.url) {
      webView.loadRequest(NSURLRequest(URL: nu))
    }
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBarHidden = false
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */

}
