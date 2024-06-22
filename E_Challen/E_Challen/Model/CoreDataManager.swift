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
    
}
