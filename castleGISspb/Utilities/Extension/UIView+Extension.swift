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
}
