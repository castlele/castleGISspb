//
//  UIView+Extension.swift
//  castleGIS
//
//  Created by Nikita Semenov on 05.03.2021.
//

import Foundation
import UIKit

extension UIView {
	
	func addSubviews(_ views: UIView...) {
		for view in views {
			self.addSubview(view)
		}
	}

	func setShadow(_ shadow: Shadow) {
		self.layer.shadowRadius = shadow.radius
		self.layer.shadowOffset = shadow.offset
		self.layer.shadowOpacity = shadow.opacity
		self.layer.shadowColor = shadow.color.cgColor
	}
}
