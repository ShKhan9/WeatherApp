//
//  HistoryVC.swift
//  WeatherDemo
//
//  Created by MacBook Pro on 9/3/21.
//

import UIKit
class HistoryVC: UIViewController {
    
    // Define all UI properties
    var closeBu:UIButton!
    var headerlb:UILabel!
    var historyTv:UITableView!
    
    // Define all data related properties
    let historyVM = HistoryVM()
    var allHistory = [WeatherInfo]()
    var city:City!
    
    // Set empty view for programmatic vc
    override func loadView() {
        view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = viewThemeColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //  Get all weather info for a city
        allHistory = historyVM.getHistoryFor(city.id)
        configUI()
    }
    func configUI() {
        addHeader()
        addCloseBu()
        addBottomStyling(CGPoint(x: 1.0, y:0.55))
        addTable()
    }
    func addHeader() {
        headerlb = UILabel()
        let name = city.name!.components(separatedBy: ",").first!
        headerlb.text = "\(name) \n historical".uppercased()
        headerlb.textAlignment = .center
        headerlb.numberOfLines = 0
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
        closeBu.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        closeBu.titleLabel!.font = UIFont.systemFont(ofSize: 25)
        closeBu.contentHorizontalAlignment = .left
        closeBu.contentVerticalAlignment = .top
        closeBu.imageEdgeInsets = UIEdgeInsets(top: 22.0, left: 20.0, bottom: 0.0, right: 0.0)
        closeBu.setBackgroundImage(UIImage(named: "Button_modal".themed), for: .normal)
        closeBu.tintColor = currentThemeColor
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
  
    func addTable() {
        historyTv = UITableView(frame: CGRect.zero, style: .plain)
        historyTv.translatesAutoresizingMaskIntoConstraints = false
        historyTv.delegate = self
        historyTv.dataSource = self
        historyTv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        historyTv.rowHeight = 100
        historyTv.backgroundColor = .clear
        let back = UIView()
        back.backgroundColor = .clear
        historyTv.tableFooterView = back
        view.addSubview(historyTv)
        NSLayoutConstraint.activate([
            historyTv.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            historyTv.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            historyTv.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            historyTv.topAnchor.constraint(equalTo: closeBu.bottomAnchor,constant: 20)
        ])
        
    }
    // dismiss vc when user clicks back button
    @objc func backButtonClicked(_ sender:UIButton) {
         
        self.dismiss(animated: true, completion:nil)
    }
    
}
 


extension HistoryVC:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        let item = allHistory[indexPath.row]
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        cell.textLabel?.textColor = otherThemeColor
        cell.textLabel?.text = item.date!.toDateString()
        cell.textLabel?.font = UIFont(name: "SFProText-Bold", size: 16)
        
        cell.detailTextLabel?.textColor = getAppThemeColor()
        cell.detailTextLabel?.text = item.desc! + ", " + item.temp!
        cell.detailTextLabel?.font = UIFont(name: "SFProText-Bold", size: 19)
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
  
}
