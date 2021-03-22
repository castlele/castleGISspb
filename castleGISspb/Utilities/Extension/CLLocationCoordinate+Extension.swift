//
//  CLLocationCoordinate2D+Extension.swift
//  castleGIS
//
//  Created by Nikita Semenov on 04.03.2021.
//

import Foundation
import ArcGIS

typealias Location2D = CLLocationCoordinate2D

extension CLLocationCoordinate2D {
	init(coordinates: Coordinates) {
		self.init()
		
		self.longitude = coordinates.lon
		self.latitude = coordinates.lat
	}
	
	init(_ array: [Double]) {
		self.init()
		
		self.longitude = array[0]
		self.latitude = array[1]
	}
}
