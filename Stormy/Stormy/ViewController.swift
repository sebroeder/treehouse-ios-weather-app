//
//  ViewController.swift
//  Stormy
//
//  Created by Sebastian Röder on 20/10/14.
//  Copyright (c) 2014 Sebastian Röder. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private let apiKey = "6ea20cf36ccb1749c1d9d3a21609d414"
    private let apiBaseURL = "https://api.forecast.io/forecast"
    private let windhoek = (latitude: "-22.565269", longitude: "17.071089")

    override func viewDidLoad() {
        super.viewDidLoad()

        let forecastURL = forecastURLWithLatitude(windhoek.latitude, longitude: windhoek.longitude)
        let sharedSession = NSURLSession.sharedSession()

        let downloadTask = sharedSession.downloadTaskWithURL(forecastURL, completionHandler:
            { (location: NSURL!, response: NSURLResponse!, error: NSError!) -> Void in

                let statusCode = (response as NSHTTPURLResponse).statusCode

                if error == nil && statusCode == 200 {
                    let forecastData = NSData(contentsOfURL: location)
                    let forecastJSON = NSJSONSerialization.JSONObjectWithData(forecastData,
                        options: nil, error: nil) as NSDictionary
                }
        })

        downloadTask.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func forecastURLWithLatitude(latitude: String, longitude: String) -> NSURL {
        return NSURL(string: "\(apiBaseURL)/\(apiKey)/\(latitude),\(longitude)")
    }


}

