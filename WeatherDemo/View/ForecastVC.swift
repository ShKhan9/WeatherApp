//
//  ViewController.swift
//  WeatherForecast
//
//  Created by MacBook Pro on 12/7/20.
//  Copyright © 2020 MailMedia. All rights reserved.
//

import UIKit
import CoreLocation

class ForecastVC: UIViewController {
    // IB Outlets
    @IBOutlet weak var citiesTv: UITableView!
    @IBOutlet weak var placelb: UILabel!
    @IBOutlet weak var stView: UIStackView!
    var plusBu:UIButton!
    var backBu:UIButton!
    var headerlb:UILabel!
    var addTexF:UITextField!
    var textContentView:UIView!
    var doneBu:UIButton!
    var cancelBu:UIButton!
    var emptylb:UILabel!
    var themeSeg:UISegmentedControl!
    var allCities = [City]()
    // ViewModel to call api and get data
    let res = WeatherVM()
    let vm = MainVM()
    let homeViewModel = HomeVM()
    var currentCity = ""
    // table data source array for the tableView
    var tableSourceArr = [Main]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // set table delegate & dataSource to the vc then register the cell
        citiesTv.delegate = self
        citiesTv.dataSource = self
        citiesTv.register(UINib.init(nibName: "MainTableCell", bundle: nil), forCellReuseIdentifier: "cell")
        // set current city to retieve it's data
        setCity()
        configUI()
 
    }
    // Add all ui elements
    func configUI() {
        addHeader()
        addPlusBu()
        addBackBu()
        addThemeSegment()
        addBottomStyling(CGPoint(x: 1.0, y:0.55))
        addTextContentView()
    }
    // Add top header label
    func addHeader() {
        headerlb = UILabel()
        headerlb.text = "FORECAST WEATHER"
        headerlb.textColor = otherThemeColor
        headerlb.font = UIFont(name: "SFProText-Bold", size: 21)
        headerlb.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerlb)
        NSLayoutConstraint.activate([
            headerlb.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            headerlb.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    // Add top plus button
    func addPlusBu() {
        plusBu = UIButton(type: .system)
        plusBu.setTitle(String(format: "%C",0xf002), for: .normal)
        plusBu.titleLabel?.font = UIFont(name: "FontAwesome", size: 25)
        plusBu.setTitleColor(otherThemeColor, for: .normal)
        plusBu.addTarget(self, action: #selector(self.addButtonClicked(_:)), for:.touchUpInside)
        plusBu.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(plusBu)
        NSLayoutConstraint.activate([
            plusBu.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
            plusBu.centerYAnchor.constraint(equalTo: headerlb.centerYAnchor),
        ])
    }
    // Add top back button
    func addBackBu() {
        backBu = UIButton(type: .system)
        backBu.setTitle(String(format: "%C",0xf053), for: .normal)
        backBu.titleLabel?.font = UIFont(name: "FontAwesome", size: 25)
        backBu.setTitleColor(otherThemeColor, for: .normal)
        backBu.addTarget(self, action: #selector(self.backButtonClicked(_:)), for:.touchUpInside)
        backBu.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backBu)
        NSLayoutConstraint.activate([
            backBu.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            backBu.centerYAnchor.constraint(equalTo: headerlb.centerYAnchor),
        ])
    }
    
    // Add text container view and hide it initially
    func addTextContentView() {
        textContentView = UIView()
        textContentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textContentView)
  
        cancelBu = UIButton(type: .system)
        cancelBu.tintColor = otherThemeColor
        cancelBu.setTitleColor(otherThemeColor, for: .normal)
        cancelBu.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        cancelBu.addTarget(self, action: #selector(self.cancelButtonClicked(_:)), for:.touchUpInside)
        cancelBu.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cancelBu)
        
        NSLayoutConstraint.activate([
            cancelBu.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 5),
            cancelBu.centerYAnchor.constraint(equalTo: textContentView.centerYAnchor),
            cancelBu.widthAnchor.constraint(equalToConstant: 50),
            cancelBu.heightAnchor.constraint(equalToConstant: 50)
       ])
        

        NSLayoutConstraint.activate([
            textContentView.centerYAnchor.constraint(equalTo: headerlb.centerYAnchor),
            textContentView.leadingAnchor.constraint(equalTo: cancelBu.trailingAnchor,constant:5),
            textContentView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -15),
            textContentView.heightAnchor.constraint(equalToConstant: 55)
        ])
         
        doneBu = UIButton(type: .system)
        doneBu.setTitle("Add", for: .normal)
        doneBu.titleLabel!.font = UIFont.systemFont(ofSize: 20)
        doneBu.setTitleColor(otherThemeColor, for: .normal)
        doneBu.addTarget(self, action: #selector(self.doneButtonClicked(_:)), for:.touchUpInside)
        doneBu.translatesAutoresizingMaskIntoConstraints = false
        textContentView.addSubview(doneBu)
        NSLayoutConstraint.activate([
            doneBu.trailingAnchor.constraint(equalTo: textContentView.trailingAnchor,constant: -10),
            doneBu.centerYAnchor.constraint(equalTo: textContentView.centerYAnchor),
            doneBu.widthAnchor.constraint(equalToConstant: 40),
        ])
         
        addTexF = UITextField()
        addTexF.addPlaceholder("Enter city name")
        addTexF.textColor = otherThemeColor
        addTexF.font = UIFont(name: "SFProText-Bold", size: 21)
        addTexF.translatesAutoresizingMaskIntoConstraints = false
        textContentView.addSubview(addTexF)
        NSLayoutConstraint.activate([
            addTexF.leadingAnchor.constraint(equalTo: textContentView.leadingAnchor,constant: 10),
            addTexF.trailingAnchor.constraint(equalTo: doneBu.leadingAnchor,constant: -10),
            addTexF.centerYAnchor.constraint(equalTo: textContentView.centerYAnchor),
        ])
        
        textContentView.layer.cornerRadius = 15
        textContentView.layer.borderColor = otherThemeColor.cgColor
        textContentView.layer.borderWidth = 1
        textContentView.isHidden = true
        cancelBu.isHidden = true
        
    }
    // Add no cities label
    func addEmptylb() {
        guard allCities.isEmpty else { return }
        emptylb = UILabel()
        emptylb.text = "There is no data to show , click above search to add a city"
        emptylb.textColor = otherThemeColor
        emptylb.textAlignment = .center
        emptylb.numberOfLines = 0
        emptylb.font = UIFont(name: "SFProText-Bold", size: 21)
        emptylb.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptylb)
        NSLayoutConstraint.activate([
            emptylb.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:20),
            emptylb.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            emptylb.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    // Add switch for theme change
    func addThemeSegment() {
        themeSeg = UISegmentedControl(items: ["City Name","Zip Code","Lat/Lon","Current Loc"])
        themeSeg.selectedSegmentTintColor = getAppThemeColor()
        themeSeg.selectedSegmentIndex = 0
        themeSeg.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : otherThemeColor], for: .normal)
        themeSeg.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : currentThemeColor], for: .selected)
        themeSeg.translatesAutoresizingMaskIntoConstraints = false
        themeSeg.addTarget(self, action: #selector(self.segChanged(_:)), for:.valueChanged)
        view.addSubview(themeSeg)
        NSLayoutConstraint.activate([
            themeSeg.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            themeSeg.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            themeSeg.topAnchor.constraint(equalTo: headerlb.bottomAnchor,constant: 30)
        ])
        themeSeg.isHidden = true
    }
    // Remove no cities label
    func removeEmptylb() {
        emptylb?.removeFromSuperview()
    }
    // Add done button tapped when user adds a city
    @objc func doneButtonClicked(_ sender:UIButton) {
        // remove white spaces from around the entered text
        let text = addTexF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if text != "" {
            // Start getting city weather info
            if themeSeg.selectedSegmentIndex == 0 {
                startSearchWithCity(text)
            }
            else
            if themeSeg.selectedSegmentIndex == 1 {
                startSearchWithZip(text)
            }
            else
            if themeSeg.selectedSegmentIndex == 2 {
                let loc = text.components(separatedBy: ",")
                guard loc.count == 2 ,
                      let lat = Double(loc.first!) ,
                      let lon = Double(loc.last!) else {showToast(message: "Invalid input data") ;  return}
                startSearchWithLoc(lat, lon: lon)
            }
            // Hide text container view
            showTextCon(false)
            addTexF.resignFirstResponder()
        }
        else {
            // Show error when user enters invalid city name
            showToast(message: "Invalid input data")
        }
    }
    
    @objc func cancelButtonClicked(_ sender:UIButton) {
        showTextCon(false)
    }
    
    @objc func segChanged(_ sender:UISegmentedControl) {
        let options = ["Enter city name","Enter zip code","Enter lat,lon","Allow current location"]
        addTexF.addPlaceholder(options[sender.selectedSegmentIndex])
        if themeSeg.selectedSegmentIndex == 3 {
            LocationSingleton.shared.delegate = self
            LocationSingleton.shared.startUpdatingLocation()
            addTexF.resignFirstResponder()
            addTexF.text = ""
            addTexF.isEnabled = false
        }
        else {
            addTexF.isEnabled = true
        }
    }
   
    // Start getting weather info for a city by name
    func startSearchWithCity(_ name:String) {
        res.getWeatherData(forCityName: name) { [weak self] res in
            if res != nil {
                // Save response to coredata
                self?.homeViewModel.saveWeatherData(res)
                self?.allCities = self?.homeViewModel.getCities() ?? []
                // Start load for company data
                self?.currentCity = self?.allCities.last?.name ?? ""
                self?.getData()
                // Remove empty label if exists
                self?.removeEmptylb()
            }
            else {
                // Show error message when there is a problem with api call
                self?.showToast(message: "Problem getting weather info, please try again with correct city name")
            }
        }
    }
    // Start getting weather info for a city by zip code
    func startSearchWithZip(_ name:String) {
        res.getWeatherData(forZipCode: name) { [weak self] res in
            if res != nil {
                // Save response to coredata
                self?.homeViewModel.saveWeatherData(res)
                self?.allCities = self?.homeViewModel.getCities() ?? []
                // Start load for company data
                self?.currentCity = self?.allCities.last?.name ?? ""
                self?.getData()
                // Remove empty label if exists
                self?.removeEmptylb()
            }
            else {
                // Show error message when there is a problem with api call
                self?.showToast(message: "Problem getting weather info, please try again with correct city name")
            }
        }
    }
    // Start getting weather info for a city by lat\lon
    func startSearchWithLoc(_ lat:Double,lon:Double) {
        res.getWeatherData(forLat: lat, andLon:lon) { [weak self] res in
            if res != nil {
                // Save response to coredata
                self?.homeViewModel.saveWeatherData(res)
                self?.allCities = self?.homeViewModel.getCities() ?? []
                // Start load for company data
                self?.currentCity = self?.allCities.last?.name ?? ""
                self?.getData()
                // Remove empty label if exists
                self?.removeEmptylb()
            }
            else {
                // Show error message when there is a problem with api call
                self?.showToast(message: "Problem getting weather info, please try again with correct city name")
            }
        }
    }
    // Action of plus button to add a new city
    @objc func addButtonClicked(_ sender:UIButton) {
            showTextCon(sender.tag == 0)
    }
    // Action of back button to add a new city
    @objc func backButtonClicked(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    // manage textfield container show/hide
    func showTextCon(_ show:Bool) {
        textContentView.isHidden = !show
        cancelBu.isHidden = !show
        headerlb.isHidden = show
        plusBu.isHidden = show
        backBu.isHidden = show
        themeSeg.isHidden = !show
        addTexF.text = ""
        plusBu.tag = show ? 1 : 0
        let _ = show ? addTexF.becomeFirstResponder() : addTexF.resignFirstResponder()
    }
    // handle table accessory click to navigate to history data for a specific city
    @objc func accessoryClicked(_ sender:UITapGestureRecognizer) {
        let vc = HistoryVC()
        vc.city = allCities[sender.view!.tag]
        self.present(vc, animated: true, completion: nil)
    }
    // start getting data inside viewDidAppear so alert can be presented in case no internet
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // start getting the data from the Api
        getData()
    }
    // set current city
    func setCity() {
       self.placelb.text = currentCity
    }
    // start getting the data
    func getData() {
        if currentCity != "" {
            vm.getData(currentCity) { res in
                if let res = res {
                    self.tableSourceArr = res
                    self.manageTableHide(false)
                    self.citiesTv.reloadData()
                    self.setCity()
                }
                else {
                    self.showAlert("Problem getting data")
                }
            }
        }
        else {
            self.manageTableHide(true)
            self.addEmptylb()
        }
    }
     
    // manage hide items
    func manageTableHide(_ hide:Bool) {
        self.placelb.isHidden =  hide
        self.stView.isHidden =  hide
        self.citiesTv.isHidden =  hide
    }
    // handle fail + no network parts
    func showAlert(_ message:String) {
        let alert = UIAlertController(title: "Error Message", message:message, preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "ReTry", style: .default, handler: { (act) in
            self.getData()
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

// implement dataSource & delegate of the collection
extension ForecastVC :  UITableViewDelegate  , UITableViewDataSource  {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableSourceArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableSourceArr[section].list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MainTableCell
        let item = tableSourceArr[indexPath.section].list[indexPath.row]
        cell.configure(item)
        cell.sepView.isHidden = indexPath.row == tableSourceArr[indexPath.section].list.count - 1
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let item = tableSourceArr[section].list.first!
        let lbl = UILabel()
        lbl.font = UIFont(name: "TimesNewRomanPS-BoldMT", size: 16)
        lbl.text = "   " + getDateFromTimeStamp(Double(item.dt))
        lbl.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        return lbl
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
}
 
extension ForecastVC:LocationServiceDelegate {
    func tracingLocation(currentLocation: CLLocation) {
        let loc = currentLocation.coordinate
        startSearchWithLoc(loc.latitude, lon: loc.longitude)
    }
    func tracingLocationDidFailWithError(error: NSError) {
    }
     
}



