//
//  ShowCityVC.swift
//  WeatherDemo
//
//  Created by MacBook Pro on 9/3/21.
//

import UIKit
class ShowCityVC: UIViewController {
    // Define all UI properties
    var closeBu:UIButton!
    var headerlb:UILabel!
    var roundedView:UIView!
    
    // Define all data related properties
    let showViewModel = ShowCityVM()
    var city:City!
    var weatherInfo:WeatherInfo!
    
    // Set empty view for programmatic vc
    override func loadView() {
        view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = viewThemeColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //  Get all latest city weather info
        weatherInfo = showViewModel.getLastWetherInfoFor(city.id)
        configUI()
    }
    func configUI() {
        addHeader()
        addCloseBu()
        addBottomStyling(CGPoint(x: 1.0, y:0.1))
        addRoundedView()
        addBottomlb()
    }
    func addHeader() {
        headerlb = UILabel()
        headerlb.text = city.name!.capitalized.replacingOccurrences(of: ",", with: " ").uppercased()
        headerlb.textColor = otherThemeColor
        headerlb.font = UIFont(name: "SFProText-Bold", size: 21)
        headerlb.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerlb)
        NSLayoutConstraint.activate([
            headerlb.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            headerlb.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    func addCloseBu() {
        closeBu = UIButton(type: .system)
        closeBu.setTitle("X", for: .normal)
        closeBu.titleLabel!.font = UIFont.systemFont(ofSize: 25)
        closeBu.contentHorizontalAlignment = .left
        closeBu.contentVerticalAlignment = .top
        closeBu.titleEdgeInsets = UIEdgeInsets(top: 20.0, left: 25.0, bottom: 0.0, right: 0.0)
        closeBu.setBackgroundImage(UIImage(named: "Button_modal".themed), for: .normal)
        closeBu.setTitleColor(currentThemeColor, for: .normal)
        closeBu.addTarget(self, action: #selector(self.backButtonClicked(_:)), for:.touchUpInside)
        closeBu.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeBu)
        NSLayoutConstraint.activate([
            closeBu.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            closeBu.centerYAnchor.constraint(equalTo: headerlb.centerYAnchor,constant: 16),
            closeBu.widthAnchor.constraint(equalToConstant: 101),
            closeBu.heightAnchor.constraint(equalToConstant: 113)
        ])
    }
  
    func addRoundedView() {
        roundedView = UIView()
        roundedView.clipsToBounds = true
        roundedView.translatesAutoresizingMaskIntoConstraints = false
        roundedView.backgroundColor = isLight ? .white : UIColor(hexString: "#2E2E2E")
        roundedView.layer.cornerRadius = 30
        roundedView.clipsToBounds = true
        view.addSubview(roundedView)
        NSLayoutConstraint.activate([
            roundedView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            roundedView.topAnchor.constraint(equalTo: headerlb.bottomAnchor,constant:50),
            roundedView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor,multiplier: 0.8),
        ])
        
        let icon = ImageLoader()
        icon.loadImageWithUrl(URL(string: "https://openweathermap.org/img/w/\(weatherInfo.icon!).png")!)
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.backgroundColor = .clear
        icon.layer.cornerRadius = 30
        icon.clipsToBounds = true
        roundedView.addSubview(icon)
        NSLayoutConstraint.activate([
            icon.centerXAnchor.constraint(equalTo: roundedView.centerXAnchor),
            icon.topAnchor.constraint(equalTo: roundedView.topAnchor,constant:70),
            icon.widthAnchor.constraint(equalToConstant: 70),
            icon.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        let mainStack = UIStackView()
        mainStack.axis = .vertical
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        roundedView.addSubview(mainStack)
        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: roundedView.leadingAnchor,constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: roundedView.trailingAnchor,constant: -20),
            mainStack.topAnchor.constraint(equalTo: icon.bottomAnchor,constant:70),
            mainStack.bottomAnchor.constraint(equalTo: roundedView.bottomAnchor,constant:-10)
        ])
        
        // Add sub items to main stack
        mainStack.addArrangedSubview(creatRowStack("DESCRIPTION", weatherInfo.desc!))
        mainStack.addArrangedSubview(creatRowStack("TEMPERATURE", weatherInfo.temp!))
        mainStack.addArrangedSubview(creatRowStack("HUMIDTY", weatherInfo.humidity!))
        mainStack.addArrangedSubview(creatRowStack("SPEED", weatherInfo.speed!))
    }
    
    // Create a row for every supplied key,value
    func creatRowStack(_ key:String,_ value:String) -> UIStackView {
        let subStack = UIStackView()
        subStack.axis = .horizontal
        subStack.distribution = .fillEqually
        subStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subStack.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Create key label
        let keylb = UILabel()
        keylb.textColor = otherThemeColor
        keylb.textAlignment = .left
        keylb.text = key
        
        // Create value label
        let valuelb = UILabel()
        valuelb.font = UIFont(name: "SFProText-Bold", size: 21)
        valuelb.textColor = getAppThemeColor()
        valuelb.textAlignment = .right
        valuelb.text = value
       
        // add labels to sub stack
        subStack.addArrangedSubview(keylb)
        subStack.addArrangedSubview(valuelb)
        
        return subStack
    }
    // Create bottom information label
    func addBottomlb() {
        let bottomlb = UILabel()
        bottomlb.textColor = otherThemeColor
        bottomlb.textAlignment = .center
        let name = city.name!.components(separatedBy: ",").first!.uppercased()
        bottomlb.text = "Weather information for \(name) received on \((weatherInfo.date!.toDateString()))"
        bottomlb.numberOfLines = 0
        bottomlb.textColor = otherThemeColor
        bottomlb.font = UIFont(name: "SFProText-Bold", size: 17)
        bottomlb.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomlb)
        NSLayoutConstraint.activate([
            bottomlb.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bottomlb.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomlb.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    // dismiss vc when user clicks back button
    @objc func backButtonClicked(_ sender:UIButton) {
         
        self.dismiss(animated: true, completion:nil)
    }
    
}
 
