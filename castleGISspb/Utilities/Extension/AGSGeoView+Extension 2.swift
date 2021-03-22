//
//  AGSGeoView+Extension.swift
//  castleGIS
//
//  Created by Nikita Semenov on 04.03.2021.
//

import Foundation
import ArcGIS

extension AGSGeoView {
	
	func showLocationCallout(at point: AGSPoint) {
		self.callout.title = "Location"
		self.callout.detail = String(format: "x: %.2f, y: %.2f", point.x, point.y)
		self.callout.isAccessoryButtonHidden = true
		self.callout.show(at: point, screenOffset: CGPoint.zero, rotateOffsetWithMap: false, animated: true)
	}
}
