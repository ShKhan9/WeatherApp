//
//  Loader.swift
//  WeatherForecast
//
//  Created by MacBook Pro on 12/7/20.
//  Copyright © 2020 MailMedia. All rights reserved.
//

import Foundation
import UIKit
public class Indicator {
    public static let shared = Indicator()
    var blurImg = UIImageView()
    var indicator = UIActivityIndicatorView()
    init() {
        blurImg.frame = UIScreen.main.bounds
        blurImg.backgroundColor = UIColor.black
        blurImg.isUserInteractionEnabled = true
        blurImg.alpha = 0.5
        indicator.style = UIActivityIndicatorView.Style.large
        indicator.center = blurImg.center
        indicator.startAnimating()
        indicator.color = UIColor.link
    }
    func show() {
        DispatchQueue.main.async {
            (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.addSubview(self.blurImg)
            (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.addSubview(self.indicator)
        }
    }
    func hide() {
        DispatchQueue.main.async {
                self.blurImg.removeFromSuperview()
                self.indicator.removeFromSuperview()
        }
    }
}
