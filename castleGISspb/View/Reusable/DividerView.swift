//
//  DividerView.swift
//  castleGISspb
//
//  Created by Nikita Semenov on 09.03.2021.
//

import Foundation
import UIKit

class DividerView: UIView {
	
	private let DEFAULT_COLOR = ColorPicker.getSubAccentColor()
	private let DEFAULT_CORNER_RADIUS : CGFloat = Measurements.getCornerRadius() - 10
	
	let DEFAULT_HEIGHT : CGFloat = 2
	
	private override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	convenience init() {
		self.init(frame: .zero)
		
		translatesAutoresizingMaskIntoConstraints = false
		backgroundColor = DEFAULT_COLOR
		layer.cornerRadius = DEFAULT_CORNER_RADIUS
	}
	
	convenience init(with color: UIColor?) {
		self.init(frame: .zero)
		
		translatesAutoresizingMaskIntoConstraints = false
		backgroundColor = color
		layer.cornerRadius = DEFAULT_CORNER_RADIUS
	}
}
