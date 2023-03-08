//
//  HomeVC.swift
//  WeatherDemo
//
//  Created by MacBook Pro on 9/3/21.
//

import UIKit
import CoreLocation
class CurrentWeatherVC: UIViewController {

    // Define all UI properties
    var citiesTv:UITableView!
    var plusBu:UIButton!
    var backBu:UIButton!
    var headerlb:UILabel!
    var addTexF:UITextField!
    var textContentView:UIView!
    var doneBu:UIButton!
    var cancelBu:UIButton!
    var emptylb:UILabel!
    var themeSeg:UISegmentedControl!
    
    // Define all data related properties
    let res = WeatherVM()
    let homeViewModel = HomeVM()
    var allCities = [City]()
    
    // Set empty view for programmatic vc
    override func loadView() {
        view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = viewThemeColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //  Get all cities stored in coredata
        allCities = homeViewModel.getCities()
        // Add no cities label if cities has no data
        addEmptylb() 
        configUI()
    }
    // Add all ui elements
    func configUI() {
        addHeader()
        addPlusBu()
        addBackBu()
        addThemeSegment()
        addBottomStyling(CGPoint(x: 1.0, y:0.55))
        addTable()
        addTextContentView()
    }
    // Add top header label
    func addHeader() {
        headerlb = UILabel()
        headerlb.text = "CURRET WEATHER"
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
    // Add cities table
    func addTable() {
        citiesTv = UITableView(frame: CGRect.zero, style: .plain)
        citiesTv.translatesAutoresizingMaskIntoConstraints = false
        citiesTv.delegate = self
        citiesTv.dataSource = self
        citiesTv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        citiesTv.backgroundColor = .clear
        let back = UIView()
        back.backgroundColor = .clear
        citiesTv.tableFooterView = back
        view.addSubview(citiesTv)
        NSLayoutConstraint.activate([
            citiesTv.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            citiesTv.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            citiesTv.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            citiesTv.topAnchor.constraint(equalTo: headerlb.bottomAnchor,constant: 80)
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
                // Refresh the tableView after data changed
                self?.citiesTv.reloadData()
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
                // Refresh the tableView after data changed
                self?.citiesTv.reloadData()
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
                // Refresh the tableView after data changed
                self?.citiesTv.reloadData()
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

}
  
extension CurrentWeatherVC:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! 
        let item = allCities[indexPath.row]
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        cell.textLabel?.textColor = otherThemeColor
        cell.textLabel?.text = item.name
        cell.textLabel?.font = UIFont(name: "SFProText-Bold", size: 19)
        cell.selectionStyle = .none
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imgView.isUserInteractionEnabled = true
        imgView.tag = indexPath.row
        imgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(accessoryClicked)))
        imgView.image = UIImage(systemName: "chevron.right")!
        imgView.tintColor = getAppThemeColor()
        cell.accessoryView = imgView
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Display city latest weather data
        let vc = ShowCityVC()
        vc.city = allCities[indexPath.row]
        self.present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Enable editing for delete
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let item = allCities[indexPath.row]
            // Delete city when user swips
            homeViewModel.deleteCity(item)
            // Update table dataSource array
            allCities.remove(at: indexPath.row)
            // Remove empty label if exists
            addEmptylb()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
  
}

extension CurrentWeatherVC:LocationServiceDelegate {
    func tracingLocation(currentLocation: CLLocation) {
        let loc = currentLocation.coordinate
        startSearchWithLoc(loc.latitude, lon: loc.longitude)
    }
    func tracingLocationDidFailWithError(error: NSError) {
    }
     
}



