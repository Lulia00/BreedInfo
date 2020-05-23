//
//  BreedsModel.swift
//  App
//
//  Created by Yulia Malaya on 17.05.2020.
//  Copyright © 2020 Yulia Malaya. All rights reserved.
//

import Foundation

struct Weight: Decodable  {
    let imperial:String?
    let metric:String?
}

struct Breeds: Decodable {
    let name: String?
    let life_span: String?
    let origin: String?
    var weight:Weight?
    let affection_level: Int?
    let energy_level: Int?
    let grooming: Int?
    let health_issues: Int?
    let intelligence: Int?
}
