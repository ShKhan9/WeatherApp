//
//  Helper.swift
//  WeatherForecast
//
//  Created by MacBook Pro on 12/7/20.
//  Copyright © 2020 MailMedia. All rights reserved.
//

import Foundation
import SystemConfiguration
import AVKit
import AssetsLibrary
func getDateFromTimeStamp(_ timeStamp : Double) -> String {
    let date = Date(timeIntervalSince1970: timeStamp)
    let dayTimePeriodFormatter = DateFormatter()
    dayTimePeriodFormatter.dateFormat = "EEEE,MMMM dd"
    let dateString = dayTimePeriodFormatter.string(from: date as Date)
    return dateString
}

func getTimeFromTimeStamp(_ timeStamp : Double) -> String {
    let date = Date(timeIntervalSince1970: timeStamp)
    let dayTimePeriodFormatter = DateFormatter()
    dayTimePeriodFormatter.dateFormat = "HH"
    let dateString = dayTimePeriodFormatter.string(from: date as Date)
    return dateString
}
 
func getDayFromTimeStamp(_ timeStamp : Double) -> String {
    let date = Date(timeIntervalSince1970: timeStamp)
    let dayTimePeriodFormatter = DateFormatter()
    dayTimePeriodFormatter.dateFormat = "dd"
    let dateString = dayTimePeriodFormatter.string(from: date as Date)
    return dateString
}

func fromKelvinToCelsius(_ kelvin:Double) -> String {
    let res = kelvin - 273.15
    return String(Int(res)) + "°"
}
 
func noNetwork() -> Bool  {
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)
    guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
            zeroSockAddress in SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)}
    } ) else {
        return false
    }
    var flags = SCNetworkReachabilityFlags()
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags)
    {
        return false
    }
    let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
    let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
    return !(isReachable && !needsConnection)
}
