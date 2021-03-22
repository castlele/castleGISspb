//
//  AGSGeoView+Extension.swift
//  castleGIS
//
//  Created by Nikita Semenov on 04.03.2021.
//

import UIKit
import ArcGIS

extension AGSGeoView {
	
	func showLocationCallout(at point: AGSPoint) {
		self.callout.title = "Location"
		self.callout.detail = String(format: "Latitude: %f, Longitude: %f", point.toCLLocationCoordinate2D().latitude, point.toCLLocationCoordinate2D().longitude)
		self.callout.isAccessoryButtonHidden = true
		self.callout.show(at: point, screenOffset: CGPoint.zero, rotateOffsetWithMap: false, animated: true)
	}
	
	func showCallout(withTitle title: String, withGraphics graphic: AGSGraphic, at point: AGSPoint , withInfoButton button: UIButton) {
		generalSetup(title: title)
		
		infoButtonSetUp(button)
		
		self.callout.show(for: graphic, tapLocation: point, animated: true)
	}
	
	private func generalSetup(title: String) {
		self.callout.title = title
		
		self.callout.isAccessoryButtonHidden = true
		
		self.callout.layer.cornerRadius = Measurements.getCornerRaduis()
		self.callout.borderWidth = 2
		self.callout.borderColor = ColorPicker.getSubMainColor()

	}
	
	private func infoButtonSetUp(_ button: UIButton) {
		callout.addSubview(button)
		
		setInfoButtonConstraints(button)
	}
	
	private func setInfoButtonConstraints(_ button: UIButton) {
		NSLayoutConstraint.activate([
			button.trailingAnchor.constraint(equalTo: callout.trailingAnchor, constant: -2.5),
			button.topAnchor.constraint(equalTo: callout.topAnchor)
		])
	}
}
