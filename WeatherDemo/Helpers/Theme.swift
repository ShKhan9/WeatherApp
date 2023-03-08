//
//  Theme.swift
//  WeatherDemo
//
//  Created by MacBook Pro on 9/3/21.
//

import Foundation
import UIKit
// App theme
var isLight = true
// Current color according to app current theme
var currentThemeColor:UIColor {
   return isLight ? UIColor.white : UIColor.black
}
// Reverse color according to app current theme
var otherThemeColor:UIColor {
   return isLight ? UIColor(hexString:"#3D4548") : UIColor(hexString: "#797F88")
}
// VC's view theme background color
var viewThemeColor:UIColor {
   return isLight ? UIColor.white : UIColor(hexString: "#262627")
} 
// Add naming prefix to image string name to get proper image name for current theme ... Assets.xcassets
extension String {
    var themed:String {
        let prefix =  isLight ? "Light" : "Dark"
        return prefix + self
    }
}
