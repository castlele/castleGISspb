//
//  DistrictObject.swift
//  castleGIS
//
//  Created by Nikita Semenov on 03.03.2021.
//

import Foundation

struct District: Codable {
	
	let id: Int
	let localName: String
	let center: [Double]
	let coordinates: [[Double]]
}
