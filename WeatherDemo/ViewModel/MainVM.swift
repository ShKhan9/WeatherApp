//
//  MainViewModel.swift
//  WeatherForecast
//
//  Created by MacBook Pro on 12/7/20.
//  Copyright © 2020 MailMedia. All rights reserved.
//

import Foundation

class MainVM {
    
    // openWeather api key
    let key = "7ea9099c53abf219269dc7e1eff2e68a"
    // openWeather server url
    let path = "https://api.openweathermap.org/data/2.5/forecast?"
    
    // get data from server or local
    func getData(_ city:String,completion:@escaping(([Main]?) -> ())) {
            Indicator.shared.show()
            let full = path + "q=\(city)" + "&appid=\(key)"
            let url = URL(string:full)!
            let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
                guard let data = data else { return }
                DispatchQueue.main.async {
                    Indicator.shared.hide()
                    completion(self.parseData(data))
                }
            }
            task.resume()
    }
    // convert data to model array
    func parseData(_ data:Data) -> [Main]? {
          do {
            let res = try JSONDecoder().decode(Root.self, from:data)
            let rem = Dictionary(grouping: res.list, by:{ Int(getDayFromTimeStamp($0.dt))! })
            var result:[Main] = rem.map { item in
                let items = item.value.sorted { $0.dt < $1.dt }
                return Main(index:item.key,list:items)
            }
            result.sort { $0.index < $1.index }
            return result
        }
        catch {
            print(error)
            return nil
        }
    }
     
}
