//
//  MainTableCell.swift
//  WeatherForecast
//
//  Created by MacBook Pro on 12/7/20.
//  Copyright © 2020 MailMedia. All rights reserved.
//

import UIKit

class MainTableCell: UITableViewCell {
    
    // IB Outlets
    @IBOutlet weak var timelb: UILabel!
    @IBOutlet weak var img: ImageLoader!
    @IBOutlet weak var templb: UILabel!
    @IBOutlet weak var windlb: UILabel!
    @IBOutlet weak var sepView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // configure cell with model
    
    func configure(_ item:List) {
        self.timelb.text = getTimeFromTimeStamp(item.dt)
        self.windlb.text = "\(item.wind.speed)"
        self.templb.text = fromKelvinToCelsius(item.main.temp)
        let imgUrl = URL(string:"https://openweathermap.org/img/wn/" + item.weather.first!.icon + "@2x.png")!
        self.img.loadImageWithUrl(imgUrl)
        self.selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
