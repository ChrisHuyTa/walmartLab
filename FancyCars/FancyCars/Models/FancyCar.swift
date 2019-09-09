//
//  FancyCar.swift
//  FancyCars
//
//  Created by Chris Ta on 2019-09-08.
//  Copyright © 2019 WalmartLab. All rights reserved.
//

import Foundation

struct FancyCar: Codable {
    var imageUrl: String?
    var make: String
    var model: String
    var year: String
    var name: String
    var id: Int
}
