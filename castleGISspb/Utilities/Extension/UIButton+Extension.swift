//
//  UIButton+Extension.swift
//  castleGISspb
//
//  Created by Nikita Semenov on 12.03.2021.
//

import Foundation
import UIKit

extension UIButton {
	
	func setShadow(_ shadow: Shadow) {
		self.layer.shadowRadius = shadow.radius
		self.layer.shadowOffset = shadow.offset
		self.layer.shadowOpacity = shadow.opacity
		self.layer.shadowColor = shadow.color.cgColor
	}
}
