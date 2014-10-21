//
//  CurrentWeather.swift
//  Stormy
//
//  Created by Sebastian Röder on 21/10/14.
//  Copyright (c) 2014 Sebastian Röder. All rights reserved.
//

import Foundation
import UIKit

struct CurrentWeather {

    let currentTime: Int
    let temperature: Int
    let humidity: Double
    let precipitationProbability: Double
    let summary: String
    let iconName: String

    var timeString: String {
        let weatherDate = NSDate(timeIntervalSince1970: NSTimeInterval(currentTime))
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .ShortStyle
        return dateFormatter.stringFromDate(weatherDate)
    }

    var icon: UIImage {
        switch iconName {
        case "clear-day", "clear-night", "rain", "snow", "sleet", "wind", "fog", "cloudy",
             "partly-cloudy-day", "partly-cloudy-night":
            return UIImage(named: iconName)
        default:
            return UIImage(named: "default")
        }
    }

    init(weatherJSON: NSDictionary) {
        let current = weatherJSON["currently"] as NSDictionary

        currentTime = current["time"] as Int
        temperature = current["temperature"] as Int
        humidity = current["humidity"] as Double
        precipitationProbability = current["precipProbability"] as Double
        summary = current["summary"] as String
        iconName = current["icon"] as String
    }

}

