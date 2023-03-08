//
//  HomeViewModel.swift
//  WeatherDemo
//
//  Created by MacBook Pro on 9/3/21.
//

import Foundation
import UIKit
import CoreData

// Manage data from HistoryVC
class HistoryVM {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Get all weather request made for a specific city
    func getHistoryFor(_ id:Int32) -> [WeatherInfo] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"WeatherInfo")
        do {
            guard let cities = try context.fetch(fetchRequest) as? [WeatherInfo] else { return [] }
            let filtered = cities.filter { $0.cityId == id }
            let latest = filtered.sorted(by: {  $0.date! < $1.date! })
            return latest
        } catch {
          print(error)
          return []
        }
    }
}
