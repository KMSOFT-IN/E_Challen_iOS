//
//  Model.swift
//  E_Challen
//
//  Created by KMSOFT on 21/06/24.
//

import Foundation


class VehicleModel {
    
    var id: String?
    var vehicle_number: String?
    var createdAt: Double?
 
    init(id: String? = nil, vehicle_number: String? = nil, createdAt: Double? = nil) {
        self.id = id
        self.vehicle_number = vehicle_number
        self.createdAt = createdAt
    }
}


class HistoryModel {
    var id: String?
    var vehicle_number: String?
    var createdAt: Double?
 
    init(id: String? = nil, vehicle_number: String? = nil, createdAt: Double? = nil) {
        self.id = id
        self.vehicle_number = vehicle_number
        self.createdAt = createdAt
    }
}
