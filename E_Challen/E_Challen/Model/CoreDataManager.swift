//
//  CoreDataManager.swift
//  E_Challen
//
//  Created by KMSOFT on 21/06/24.
//

import Foundation
import CoreData
import UIKit


class CoreDataManager {
    
    private var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func addUser(_ user: VehicleModel) {
        let userEntity = Vehicle(context: context)  // creating user
        userEntity.id = user.id
        userEntity.vehicle_Number = user.vehicle_number
        userEntity.createdAt = user.createdAt ?? 0.0
        
        do {
            try context.save()
        } catch {
            print("user saving error.", error)
        }
    }
    
    func fetchUsers() -> [Vehicle] {
        var users: [Vehicle] = []
        do {
            users = try context.fetch(Vehicle.fetchRequest())
        } catch {
            print("fetch user error", error)
        }
        
        return users
    }
    
    func vehicleNumberExists(_ vehicleNumber: String) -> Bool {
          let fetchRequest: NSFetchRequest<Vehicle> = Vehicle.fetchRequest()
          fetchRequest.predicate = NSPredicate(format: "vehicle_Number == %@", vehicleNumber)
          fetchRequest.fetchLimit = 1
          
          do {
              let count = try context.count(for: fetchRequest)
              return count > 0
          } catch {
              print("Error checking vehicle number existence: \(error)")
              return false
          }
      }
    
    func addHistory(_ user: HistoryModel) {
        
        let userEntity = History(context: context) // creating user
        userEntity.id = user.id
        userEntity.vehicle_Number = user.vehicle_number
        userEntity.createdAt = user.createdAt ?? 0.0
        
        do {
            try context.save()
        } catch {
            print("user saving error.", error)
        }
    }
    
    func fetchHistory() -> [History] {
        var users: [History] = []
        do {
            users = try context.fetch(History.fetchRequest())
        } catch {
            print("fetch user error", error)
        }
        
        return users
    }
    
    
    func deleteUser(userEntity: Vehicle) {
            context.delete(userEntity)
            do {
                try context.save()
            } catch {
                print("user saving error", error)
            }
        }

    
//    func createBudgetEntityFromBudget(budget: HistoryModel) {
//        
//        let context = appDelegate.persistentContainer.viewContext
//
//        if let entityDescription = NSEntityDescription.entity(forEntityName: "History", in: context) {
//            
//            let budgetManagedObject = NSManagedObject(entity: entityDescription, insertInto: context)
//            
//            budgetManagedObject.setValue(budget.id, forKey: "id")
//            budgetManagedObject.setValue(budget.vehicle_number, forKey: "vehicle_Number")
//            budgetManagedObject.setValue(budget.createdAt, forKey: "createdAt")
//            
//            do {
//                try context.save()
//                print("Budget saved to Core Data.")
//            } catch {
//                print("Error saving Budget to Core Data: \(error.localizedDescription)")
//            }
//        }
//    }
//    
//    func fetchBudgets() -> [History] {
//        let context = appDelegate.persistentContainer.viewContext
//        let fetchRequest: NSFetchRequest<History> = History.fetchRequest()
//        
//        do {
//            let budgets = try context.fetch(fetchRequest)
//            return budgets
//        } catch {
//            print("Error fetching budgets: \(error.localizedDescription)")
//            return []
//        }
//    }
//    

    
}
