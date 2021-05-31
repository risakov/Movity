//
//  CarEntity.swift
//  Movity
//
//  Created by Роман on 29.05.2021.
//

import Foundation

enum VehicleType: String, Codable {
    
    case car = "Машина комфорт класса"
    case bicycle = "Велосипед"
    case scooter = "Электросамокат"
    
}

struct Tariff: Codable {
    
    let costForStart: Double
    let costPerMinute: Double
    let costForWaiting: Double
    let freeWaitingTime: Double
    
}

struct Coordinate: Codable {
    
    let longitude: Double
    let latitude: Double
    
}

struct VehicleEntity: Codable {
    
    let type: VehicleType
    let model: String
    let number: String
    let fuel: Double
    let coordinate: Coordinate
    let tariff: Tariff
    let address: String
    let timeToVehicle: Int
    let vehicleImageName: String
    
}
