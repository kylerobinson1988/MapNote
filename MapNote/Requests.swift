//
//  Requests.swift
//  Sweetr
//
//  Created by Kyle Brooks Robinson on 5/18/15.
//  Copyright (c) 2015 Kyle Brooks Robinson. All rights reserved.
//

import Foundation
import CoreLocation

class FourSquareRequest {
    
    let API_URL = "https://api.foursquare.com/v2/"
    let CLIENT_ID = "R5APQ5EWCJALFQN1IFMEA4FBZUNMRZBYJBCFDMHJ5RA3KQ5Q"
    let CLIENT_SECRET = "ZLR4ILCYIWUFW2LUQQZ3HZMIOKRXI3TKHCE2LHGN3SAGWYP4"
    
    func getVenuesWithLocation(location: CLLocation, completion: (venues: [AnyObject]) -> ()) {
    
    //Venues empty array
    let venues: [AnyObject] = []
    
    // Run completion closure/block and pass venues array
    completion(venues: venues)
        
        
        
    }
    
}

class TwitterRequest {
    
    let API_URL = "https://api.twitter.com/1.1/"
    let API_KEY = "xamN0kVccq9ZS4svTDeoaj9s2"
    let API_SECRET = "d8ex6Z1pyPSSVnS2NkWFJzYtjFt6gHecuPAqiGLNmIAKqowJty"
    
    var API_ENCODED: String? {
        
        get {
            
            let str = API_KEY + ":" + API_SECRET
            
            let utf8str = str.dataUsingEncoding(NSUTF8StringEncoding)
            
            guard let encoded = utf8str?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions()) else { return nil }
            
            return "Basic " + encoded

        }
        
    }
    
    var TOKEN: String? {
        
        get {
            return NSUserDefaults.standardUserDefaults().objectForKey("twitterToken") as? String
        }
        
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "twitterToken")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
    }
    
    func getToken(completion: (() -> Void)) {
        
        let endpoint = "https://api.twitter.com/oauth2/token?grant_type=client_credentials"
        
        guard let url = NSURL(string: endpoint) else { return }
        
        let request = NSMutableURLRequest(URL: url)
        
        request.HTTPMethod = "POST"
        request.setValue(API_ENCODED!, forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        
        NSURLSession.sharedSession().dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) in
            
            do {
                
                let returnInfo = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? [String:AnyObject]
                
                print(returnInfo)
                
                self.TOKEN = returnInfo!["access_token"] as? String
                
                completion()
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }

        }
        
    }
    
    func findPopularFoodTweets(completion: (tweets: [AnyObject]) -> ()) {
        
        if TOKEN == nil {
            
            getToken({ () -> () in
                
                
                // do something
                self.findPopularFoodTweets(completion)
                
            })
            
           return
            
        }
        
        let endpoint = API_URL + "search/tweets.json?q=Food&result_type=popular"
        
        if let url = NSURL(string: endpoint) {
            
            let request = NSMutableURLRequest(URL: url)
            
            request.setValue("Bearer " + TOKEN!, forHTTPHeaderField: "Authorization")
            
            NSURLSession.sharedSession().dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) in
                
                do {
                    
                    let searchInfo = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? [String:AnyObject]
                    
                    if let tweets = searchInfo!["statuses"] as? [AnyObject] {
                        print(tweets)
                        completion(tweets: tweets)
                    }
                    
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
                
            }
            
        }
        
    }
    
}