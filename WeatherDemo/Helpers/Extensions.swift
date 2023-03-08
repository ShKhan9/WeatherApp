//
//  Extennsions.swift
//  WeatherDemo
//
//  Created by MacBook Pro on 9/3/21.
//

import Foundation
import UIKit
import SystemConfiguration

// Create color from hex string
extension UIColor {

    convenience init(hexString: String) {
        var cleanedHexString = hexString
        if hexString.hasPrefix("#") {
            cleanedHexString = String(hexString.dropFirst())
        }
        let rgbValue = Scanner(string: cleanedHexString).scanInt32(representation: .hexadecimal)!
        let red = CGFloat((rgbValue >> 16) & 0xff) / 255.0
        let green = CGFloat((rgbValue >> 08) & 0xff) / 255.0
        let blue = CGFloat((rgbValue >> 00) & 0xff) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }

}


extension UIViewController {
    
    // Add background gradient to VC's view
    func addBottomStyling(_ start:CGPoint) {
            let bottomImgV = UIImageView()
            bottomImgV.backgroundColor = .clear
            bottomImgV.image = UIImage(named: "Background".themed)
            bottomImgV.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(bottomImgV)
            NSLayoutConstraint.activate([
                bottomImgV.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                bottomImgV.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                bottomImgV.heightAnchor.constraint(equalTo: bottomImgV.widthAnchor, multiplier: 223/375 , constant: 0),
                bottomImgV.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
            let gradient = CAGradientLayer()
           gradient.colors = isLight ? [UIColor.white.cgColor, UIColor(hexString: "#D6D3DE")] : [UIColor(hexString: "#262627"), UIColor(hexString: "#242325")]
            gradient.locations = [0.0 , 1.0]
            gradient.startPoint = start
            gradient.endPoint =  CGPoint(x: 1.0, y: 1.0)
            gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            self.view.layer.insertSublayer(gradient, at: 0)
    }
    // Check network status
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
    
    // Get main app theme color according to app current theme
    func getAppThemeColor() -> UIColor {
        return isLight ? UIColor(hexString: "#2388C7") : UIColor(hexString: "#C53249")
    }
    // Show toast message
    func showToast(message : String,duration:TimeInterval = 4.0,delay:TimeInterval = 2.0) {
  
        let toastLabel = PaddingLabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 40))
        toastLabel.backgroundColor = otherThemeColor
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastLabel.textColor = currentThemeColor
        toastLabel.textAlignment = .center;
        toastLabel.text = "  " + message + "  "
        toastLabel.alpha = 1.0
        toastLabel.numberOfLines = 0
        self.view.addSubview(toastLabel)
        
        NSLayoutConstraint.activate([
            toastLabel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            toastLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 40),
            toastLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: -40)
        ])
       
        UIView.animate(withDuration:duration, delay: delay, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    

   
}

extension UITextField {
    // Add placeholder with color according to current app theme
    func addPlaceholder(_ str:String) {
        self.attributedPlaceholder =
            NSAttributedString(string:str, attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray ])
        self.textColor = otherThemeColor
    }
    
}

 

extension Date {
    // Convert date to string with a specific format
    func toDateString() -> String {
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "dd.MM.yyy-hh:mm"
        let dateString = dayTimePeriodFormatter.string(from:self)
        return dateString
    }
      
}



extension String {
    // Convert Kelvin temp to Celsius temp
    func fromKelvinToCelsius() -> String {
        let value = Double(self)!
        let res = value - 273.15
        return String(Int(res)) + "° C"
    }
      
}




