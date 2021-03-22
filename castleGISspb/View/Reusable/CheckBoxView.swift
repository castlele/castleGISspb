//
//  CheckBoxView.swift
//  castleGIS
//
//  Created by Nikita Semenov on 05.03.2021.
//

import Foundation
import UIKit

final class CheckBox: UIButton {
	
	private let IMAGE_SIZE : CGFloat = 18
	
	private let checkedImage = "checkmark.circle"
	private let uncheckedImage = "circle"
	
	var isChecked: Bool = false {
		didSet {
			if isChecked {
				setupImage(image: checkedImage)
			} else {
				setupImage(image: uncheckedImage)
			}
		}
	}
	
	private override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	convenience init() {
		self.init(frame: .zero)
		
		setup()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupImage(image: String) {
		let boldConfig = UIImage.SymbolConfiguration(pointSize: IMAGE_SIZE, weight: .semibold, scale: .large)
		self.setImage(UIImage(systemName: image, withConfiguration: boldConfig)!, for:.normal)
	}
	
	private func setup() {
		self.isChecked = false
		self.translatesAutoresizingMaskIntoConstraints = false
		self.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
	}
	
	
	@objc private func buttonClicked(_ sender: UIButton) {
		if sender == self {
			isChecked = !isChecked
		}
	}
}
