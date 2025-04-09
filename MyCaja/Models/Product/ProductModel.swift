//
//  ProductModel.swift
//  MyCaja
//
//  Created by MacBook Air on 05/04/25.
//

import Foundation
import SwiftData

@Model
class ProductModel {
    @Attribute(.unique) var id: UUID
    var name: String
    var price: Double
    var available: Bool
    var presentation: PresentationEnum
    var baseUnit: BaseUnitEnum
    var image: Data?
    
    init (
        id: UUID = UUID(),
        name: String,
        price: Double,
        available: Bool,
        presentation: PresentationEnum,
        baseUnit: BaseUnitEnum,
        image: Data? = nil
    ){
        self.id = id
        self.name = name
        self.price = price
        self.available = available
        self.presentation = presentation
        self.baseUnit = baseUnit
        self.image = image
    }
}
