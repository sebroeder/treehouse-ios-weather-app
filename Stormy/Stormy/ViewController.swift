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

    @IBOutlet weak var weatherIconView: UIImageView!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        let forecastURL = forecastURLWithLatitude(windhoek.latitude, longitude: windhoek.longitude)
        let sharedSession = NSURLSession.sharedSession()

        let downloadTask = sharedSession.downloadTaskWithURL(forecastURL, completionHandler: {
            (location: NSURL!, response: NSURLResponse!, error: NSError!) -> Void in

                let statusCode = (response as NSHTTPURLResponse).statusCode

                if error == nil && statusCode == 200 {
                    let forecastData = NSData(contentsOfURL: location)!
                    let forecastJSON = NSJSONSerialization.JSONObjectWithData(forecastData,
                        options: nil, error: nil) as NSDictionary

                    let currentWeather = CurrentWeather(weatherJSON: forecastJSON)

                    dispatch_async(dispatch_get_main_queue(), { () -> Void in

                        self.weatherIconView.image = currentWeather.icon
                        self.currentTimeLabel.text = currentWeather.timeString
                        self.temperatureLabel.text = String(currentWeather.temperature)
                        self.humidityLabel.text = "\(currentWeather.humidity)"
                        self.precipitationLabel.text = "\(currentWeather.precipitationProbability)"
                        self.summaryLabel.text = currentWeather.summary
                    })
                }
        })

        downloadTask.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func forecastURLWithLatitude(latitude: String, longitude: String) -> NSURL! {
        return NSURL(string: "\(apiBaseURL)/\(apiKey)/\(latitude),\(longitude)")
    }

}

