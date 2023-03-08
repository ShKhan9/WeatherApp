//
//  HomeVC.swift
//  WeatherDemo
//
//  Created by MacBook Pro on 9/3/21.
//

import UIKit 
class HomeVC: UIViewController {

    // Define all UI properties
    var citiesTv:UITableView!
    var currentBu:UIButton!
    var forecastBu:UIButton!
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
        // Add no cities label if cities has no data
        configUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //  Get all cities stored in coredata
        allCities = homeViewModel.getCities()
        citiesTv.reloadData()
        addEmptylb()
    }
    // Add all ui elements
    func configUI() {
        addHeader()
        addCurrentBu()
        addForecastBu()
        addBottomStyling(CGPoint(x: 1.0, y:0.55))
        addTable()
    }
    // Add top header label
    func addHeader() {
        headerlb = UILabel()
        headerlb.text = "WEATHER"
        headerlb.textColor = otherThemeColor
        headerlb.font = UIFont(name: "SFProText-Bold", size: 21)
        headerlb.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerlb)
        NSLayoutConstraint.activate([
            headerlb.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            headerlb.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    // Add top current button
    func addCurrentBu() {
        currentBu = UIButton(type: .system)
        currentBu.setTitle("Current", for: .normal)
        currentBu.setTitleColor(otherThemeColor, for: .normal)
        currentBu.addTarget(self, action: #selector(self.addButtonClicked(_:)), for:.touchUpInside)
        currentBu.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(currentBu)
        NSLayoutConstraint.activate([
            currentBu.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            currentBu.centerYAnchor.constraint(equalTo: headerlb.centerYAnchor)
        ])
    }
    // Add top forecast button
    func addForecastBu() {
        forecastBu = UIButton(type: .system)
        forecastBu.setTitle("Forecast", for: .normal)
        forecastBu.setTitleColor(otherThemeColor, for: .normal)
        forecastBu.addTarget(self, action: #selector(self.forecastButtonClicked(_:)), for:.touchUpInside)
        forecastBu.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(forecastBu)
        NSLayoutConstraint.activate([
            forecastBu.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
            forecastBu.centerYAnchor.constraint(equalTo: headerlb.centerYAnchor)
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
            citiesTv.topAnchor.constraint(equalTo: headerlb.bottomAnchor,constant: 70)
        ])
        
    }
    
    // Add no cities label
    func addEmptylb() {
        emptylb?.removeFromSuperview()
        guard allCities.isEmpty else { return }
        emptylb = UILabel()
        emptylb.text = "There is no data to show , click current to add a city"
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
    // Remove no cities label
    func removeEmptylb() {
        emptylb?.removeFromSuperview()
    }
    
    @objc func cancelButtonClicked(_ sender:UIButton) {
        showTextCon(false)
    }
    
    @objc func segChanged(_ sender:UISegmentedControl) {
        isLight.toggle()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            let nav = UINavigationController(rootViewController: HomeVC())
            nav.isNavigationBarHidden = true
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = nav
        }
    }

    // Action of current button to add a new city
    @objc func addButtonClicked(_ sender:UIButton) {
            //showTextCon(sender.tag == 0)
        let vc = CurrentWeatherVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // Action of forecast button to add a new city
    @objc func forecastButtonClicked(_ sender:UIButton) {
            //showTextCon(sender.tag == 0)
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ForecastVC") as! ForecastVC
        vc.currentCity = allCities.last?.name ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }

    // manage textfield container show/hide
    func showTextCon(_ show:Bool) {
        textContentView.isHidden = !show
        cancelBu.isHidden = !show
        headerlb.isHidden = show
        currentBu.isHidden = show
        forecastBu.isHidden = show
        themeSeg.isHidden = show
        addTexF.text = ""
        currentBu.tag = show ? 1 : 0
        let _ = show ? addTexF.becomeFirstResponder() : addTexF.resignFirstResponder()
    }
    
    // handle table accessory click to navigate to history data for a specific city
    @objc func accessoryClicked(_ sender:UITapGestureRecognizer) {
        let vc = HistoryVC()
        vc.city = allCities[sender.view!.tag]
        self.present(vc, animated: true, completion: nil)
    }

}
  
extension HomeVC:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allCities.isEmpty ? 0 : 1
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
    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        // Enable editing for delete
//        return false
//    }
//
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if (editingStyle == .delete) {
//            let item = allCities[indexPath.row]
//            // Delete city when user swips
//            homeViewModel.deleteCity(item)
//            // Update table dataSource array
//            allCities.remove(at: indexPath.row)
//            // Remove empty label if exists
//            addEmptylb()
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
  
}
