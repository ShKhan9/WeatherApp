//
//  HomeViewModel.swift
//  WeatherDemo
//
//  Created by MacBook Pro on 9/3/21.
//

import Foundation
import UIKit
import CoreData

// Manage data for ShowCityVC
class ShowCityVM {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // Get the last weather request info associated with a specific city
    func getLastWetherInfoFor(_ id:Int32) -> WeatherInfo? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"WeatherInfo")
        do {
            guard let cities = try context.fetch(fetchRequest) as? [WeatherInfo] else { return nil }
            let filtered = cities.filter { $0.cityId == id }
            let latest = filtered.sorted(by: {  $0.date! < $1.date! })
            return latest.last!
        } catch {
          print(error)
          return nil
        }
    }
}
