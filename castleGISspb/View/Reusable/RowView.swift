//
//  SectionView.swift
//  castleGIS
//
//  Created by Nikita Semenov on 06.03.2021.
//

import Foundation
import UIKit

class RowView: UIView {
	
	var checkBox: CheckBox!
	let label = UILabel()
	
	private override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	convenience init(_ label: String, bgColor: UIColor?, action: Selector) {
		self.init(frame: .zero)
		
		self.label.text = label
		
		checkBox = CheckBox()
		
		initialSetup(bgColor)
		
		checkBox.addTarget(nil, action: action, for: .touchUpInside)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupLabel(textColor: UIColor?, font: UIFont?) {
		label.textColor = textColor
		label.font = font
	}
	
	func setupCheckBox(bgColor: UIColor? = nil, tintColor: UIColor?) {
		checkBox.tintColor = tintColor
		checkBox.backgroundColor = bgColor
	}
}

// MARK:- Helper functions
extension RowView {
	
	private func addSubviews() {
		self.addSubviews(checkBox, label)
	}
	
	private func initialSetup(_ color: UIColor?) {
		addSubviews()
		setConstraints()
		setBackgrount(color)
	}
	
	private func setBackgrount(_ color: UIColor?) {
		backgroundColor = color
		layer.cornerRadius = Measurements.getCornerRadius()
	}
	
	private func enableConstraints() {
		self.translatesAutoresizingMaskIntoConstraints = false
		label.translatesAutoresizingMaskIntoConstraints = false
	}
	
	private func setConstraints() {
		enableConstraints()
		
		NSLayoutConstraint.activate([
			checkBox.centerYAnchor.constraint(equalTo: self.centerYAnchor),
			checkBox.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Measurements.getPadding()),
			
			label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
			label.leadingAnchor.constraint(equalTo: checkBox.trailingAnchor, constant: 2 * Measurements.getPadding())
		])
	}
}
