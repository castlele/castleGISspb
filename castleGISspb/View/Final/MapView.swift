//
//  MapView.swift
//  castleGIS
//
//  Created by Nikita Semenov on 03.03.2021.
//

import Foundation
import ArcGIS

final class MapView {
	
	private var DEFAULT_SCALE : Double = 1_000_000
	
	var map : AGSMapView
	
	private var defaultLocation: Coordinates {
		Coordinates(lon: 30.3609, lat: 59.9311)
	}
	
	init(withBasemap: AGSBasemap = .topographicVector()) {
		self.map = AGSMapView()
		
		initialSetup(withBasemap)
	}
	
	private func initialSetup(_ basemap: AGSBasemap) {
		setupBasemap(with: basemap)
		
		map.grid = nil
		map.interactionOptions.isMagnifierEnabled = false
	}
	
	private func setupBasemap(with basemap: AGSBasemap) {
		let map = AGSMap(basemap: basemap)
		self.map.map = map
		self.map.setViewpoint(setupDefaultLocation(coordinates: defaultLocation))
	}
	
	private func setupDefaultLocation(coordinates: Coordinates) -> AGSViewpoint {
		let center = AGSPoint(clLocationCoordinate2D: Location2D(coordinates: coordinates))
		return AGSViewpoint(center: center, scale: DEFAULT_SCALE)
	}
}
