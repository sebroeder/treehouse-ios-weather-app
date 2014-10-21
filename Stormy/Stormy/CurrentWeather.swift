//
//  CurrentWeather.swift
//  Stormy
//
//  Created by Sebastian Röder on 21/10/14.
//  Copyright (c) 2014 Sebastian Röder. All rights reserved.
//

import Foundation

struct CurrentWeather {

    let currentTime: String?
    let temperature: Int
    let humidity: Double
    let precipitationProbability: Double
    let summary: String
    let iconName: String

    init(weatherJSON: NSDictionary) {
        let current = weatherJSON["currently"] as NSDictionary

        temperature = current["temperature"] as Int
        humidity = current["humidity"] as Double
        precipitationProbability = current["precipProbability"] as Double
        summary = current["summary"] as String
        iconName = current["icon"] as String

        currentTime = dataStringWithUnixTime(current["time"] as Int)
    }

    private func dataStringWithUnixTime(unixTime: Int) -> String {
        let weatherDate = NSDate(timeIntervalSince1970: NSTimeInterval(unixTime))
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .ShortStyle
        return dateFormatter.stringFromDate(weatherDate)
    }
}
