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

    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var refreshActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var weatherIconView: UIImageView!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshActivityIndicator.hidden = true
        fetchCurrentWeatherData()
    }

    @IBAction func refresh() {
        refreshButton.hidden = true
        refreshActivityIndicator.hidden = false
        refreshActivityIndicator.startAnimating()
        fetchCurrentWeatherData()
    }

    func forecastURLWithLatitude(latitude: String, longitude: String) -> NSURL! {
        return NSURL(string: "\(apiBaseURL)/\(apiKey)/\(latitude),\(longitude)")
    }

    func fetchCurrentWeatherData() {
        let forecastURL = forecastURLWithLatitude(windhoek.latitude, longitude: windhoek.longitude)
        let sharedSession = NSURLSession.sharedSession()

        let downloadTask = sharedSession.downloadTaskWithURL(forecastURL, completionHandler: {
            (location: NSURL!, response: NSURLResponse!, error: NSError!) -> Void in

            if error == nil {
                let forecastData = NSData(contentsOfURL: location)!
                let forecastJSON = NSJSONSerialization.JSONObjectWithData(forecastData,
                    options: nil, error: nil) as NSDictionary

                let currentWeather = CurrentWeather(weatherJSON: forecastJSON)

                dispatch_async(dispatch_get_main_queue(), { () -> Void in

                    self.weatherIconView.image = currentWeather.icon
                    self.currentTimeLabel.text = currentWeather.timeString
                    self.temperatureLabel.text = "\(currentWeather.temperature)"
                    self.humidityLabel.text = "\(currentWeather.humidity)"
                    self.precipitationLabel.text = "\(currentWeather.precipitationProbability)"
                    self.summaryLabel.text = currentWeather.summary

                    self.refreshActivityIndicator.stopAnimating()
                    self.refreshActivityIndicator.hidden = true
                    self.refreshButton.hidden = false
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in

                    let networkIssueController = UIAlertController(title: "Error",
                        message: "Unable to load data. Not connected to the internet.",
                        preferredStyle: .Alert)

                    let okButton = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    networkIssueController.addAction(okButton)

                    let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                    networkIssueController.addAction(cancelButton)

                    self.presentViewController(networkIssueController, animated: true, completion: nil)

                    self.refreshActivityIndicator.stopAnimating()
                    self.refreshActivityIndicator.hidden = true
                    self.refreshButton.hidden = false
                })
            }
        })
        
        downloadTask.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

