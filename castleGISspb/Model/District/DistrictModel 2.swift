//
//  DistrictModel.swift
//  castleGIS
//
//  Created by Nikita Semenov on 03.03.2021.
//

import Foundation
import ArcGIS

class DistrictModel {
	
	var districts: [String: (polygon: AGSGraphic, centerPoint: AGSGraphic)] = [:]
	
	init() {
		startRequesting()
	}
	
	private func startRequesting() {
		let url = Endpoint.urlToDistrictsJSON
		NetworkRequestor.makeRequest(to: url, with: addNewKeyValue(district:))
	}
	
	private func addNewKeyValue(district: [District]) -> Void {
		for region in district {
			DispatchQueue.main.async {
				self.insertIntoDictionary(elementWithName: region.localName, areaCoordinates: region.coordinates, centerCoordinates: region.center)
			}
		}
	}
	
	private func insertIntoDictionary(elementWithName name: String, areaCoordinates: [[Double]], centerCoordinates: [Double]) {
		let area = makeAGSGraphicForPolygon(with: areaCoordinates)
		let center = makeAGSGrapicForPoint(with: centerCoordinates)
		
		districts[name] = (area, center)
	}
	
	private func makeAGSGraphicForPolygon(with coordinates: [[Double]]) -> AGSGraphic {
		let location2DCoords = convertToLocation2D(coordinates)
		let points = convertToAGSPoint(location2DCoords)
		let polygon = convertPointsToPolygon(points)
		
		return convertToAGSGraphic(from: polygon)
	}
	
	private func makeAGSGrapicForPoint(with coordinates: [Double]) -> AGSGraphic {
		let location2DCoords = convertToLocation2D(coordinates)
		let point = convertToAGSPoint(location2DCoords)
		
		return convertToAGSGraphic(from: point)
	}
	
	private func determineColor() -> (border: UIColor, inner: UIColor) {
		var index: Int = 0
		
		if !districts.isEmpty {
			index = districts.keys.count
		}
		
		return ColorPicker.pickColors(for: index)
	}
	
	private func convertToAGSGraphic(from polygon: AGSPolygon) -> AGSGraphic {
		let color = determineColor()
		let polygonBorder = AGSSimpleLineSymbol(style: .solid, color: color.border, width: 1.5)
		let polygonSymbol = AGSSimpleFillSymbol(style: .solid, color: color.inner, outline: polygonBorder)
		
		return AGSGraphic(geometry: polygon, symbol: polygonSymbol)
	}
	
	private func convertToAGSGraphic(from point: AGSPoint) -> AGSGraphic {
		let pointSymbol = AGSSimpleMarkerSymbol(style: .circle, color: .darkGray, size: 10)
		pointSymbol.outline = AGSSimpleLineSymbol(style: .solid, color: .white, width: 1.0)
		
		return AGSGraphic(geometry: point, symbol: pointSymbol)
	}
	
	private func convertPointsToPolygon(_ points: [AGSPoint]) -> AGSPolygon {
		AGSPolygon(points: points)
	}
	
	private func convertToAGSPoint(_ arrayOfCoordinates: [Location2D]) -> [AGSPoint] {
		var points = [AGSPoint]()
		
		for coordinate in arrayOfCoordinates {
			points.append(convertToAGSPoint(coordinate))
		}
		
		return points
	}
	
	private func convertToAGSPoint(_ coordinates: Location2D) -> AGSPoint {
		AGSPoint(clLocationCoordinate2D: coordinates)
	}
	
	private func convertToLocation2D(_ nestedArrayOfDoubles: [[Double]]) -> [Location2D] {
		var locations = [Location2D]()
		
		for pair in nestedArrayOfDoubles {
			locations.append(convertToLocation2D(pair))
		}
		
		return locations
	}
	
	private func convertToLocation2D(_ arrayOfDoubles: [Double]) -> Location2D {
		Location2D(arrayOfDoubles)
	}
}
