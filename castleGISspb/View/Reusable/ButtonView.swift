//
//  ButtonView.swift
//  castleGIS
//
//  Created by Nikita Semenov on 05.03.2021.
//

import Foundation
import UIKit

class ButtonView: UIButton {
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	convenience init(bgColor: UIColor? = .white, titleColor: UIColor? = .gray, font: UIFont?, text: String, isShadow: Bool = true, shadow: Shadow? = nil) {
		self.init(frame: .zero)
		
		generalButtonSetup(bgColor: bgColor, isShadow: isShadow, shadow: shadow)
		
		setupButtonWithText(text, titleColor: titleColor, font: font)
	}
	
	convenience init(bgColor: UIColor? = .white, tintColor: UIColor? = .gray, image: String, imageConfiguration: UIImage.SymbolConfiguration? = nil, isShadow: Bool = true, shadow: Shadow? = nil) {
		self.init(frame: .zero)
		
		generalButtonSetup(bgColor: bgColor, isShadow: isShadow, shadow: shadow)
		
		setupButtonWithImage(image, configuration: imageConfiguration, tintColor: tintColor)
	}
	
	func generalButtonSetup(bgColor: UIColor?, isShadow: Bool, shadow: Shadow?) {
		turnOnConstraints()
		setBackGroundColor(bgColor)
		
		if isShadow {
			setShadow(shadow ?? Shadow())
		}
	}
	
	func setupButtonWithText(_ text: String, titleColor: UIColor?, font: UIFont?) {
		setTitleColor(titleColor)
		setupTitle(text)
		setTitleFont(font)
	}
	
	func setupButtonWithImage(_ image: String, configuration: UIImage.SymbolConfiguration?, tintColor: UIColor?) {
		setTintColor(tintColor)
		setupImage(image, configuration: configuration)
	}
	
	private func turnOnConstraints() {
		self.translatesAutoresizingMaskIntoConstraints = false
	}
	
	private func setBackGroundColor(_ color: UIColor?) {
		self.backgroundColor = color
	}
	
	private func setTitleColor(_ color: UIColor?) {
		self.setTitleColor(color, for: .normal)
		self.setTitleColor(.black, for: .selected)
	}
	
	private func setTintColor(_ color: UIColor?) {
		self.tintColor = color
	}
	
	private func setTitleFont(_ font: UIFont?) {
		self.titleLabel?.font = font
	}
	
	private func setupImage(_ image: String, configuration: UIImage.SymbolConfiguration?) {
		if let config = configuration {
			self.setImage(UIImage(systemName: image, withConfiguration: config)!, for:.normal)
		} else {
			let defaultConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .semibold, scale: .large)
			self.setImage(UIImage(systemName: image, withConfiguration: defaultConfig)!, for:.normal)
		}
	}
	
	private func setupTitle(_ text: String) {
		self.setTitle(text, for: .normal)
	}
}
