//
//  ColorPicker.swift
//  castleGIS
//
//  Created by Nikita Semenov on 05.03.2021.
//

import Foundation
import UIKit

struct ColorPicker {
	
	private static let MAIN_COLOR = UIColor(named: "main")!
	private static let SUB_MAIN_COLOR = UIColor(named: "subMain")!
	private static let SUB_ACCENT_COLOR = UIColor(named: "subAccent")!
	private static let ACCENT_COLOR = UIColor(named: "accent")!
	private static let TEXT_COLOR : UIColor = .white
	
	static func getMainColor() -> UIColor {
		MAIN_COLOR
	}
	
	static func getSubMainColor() -> UIColor {
		SUB_MAIN_COLOR
	}
	
	static func getSubAccentColor() -> UIColor {
		SUB_ACCENT_COLOR
	}
	
	static func getAccentColor() -> UIColor {
		ACCENT_COLOR
	}
	
	static func getStandardTextColor() -> UIColor {
		TEXT_COLOR
	}
	
	static func pickColors(for index: Int) -> (border: UIColor, inner: UIColor){
		(determineBorderColor(index), determineFillColor(index))
	}
	
	private static func determineFillColor(_ index: Int) -> UIColor {
		let colorName = "\(self.FillColor(rawValue: index) ?? .red)"
		return UIColor(named: colorName)!
	}
	
	private static func determineBorderColor(_ index: Int) -> UIColor {
		let colorName = "\(self.BorderColor(rawValue: index) ?? .redDark)"
		return UIColor(named: colorName)!
	}
}

// MARK:- Color sets
extension ColorPicker {
	
	enum FillColor: Int {
		case red
		case orange
		case yellow
		case lime
		case green
		case mint
		case cyan
		case lightBlue
		case blue
		case purple
		case pink
		case dragonFruit
		case salmon
		case cantaloupe
		case banana
		case honeydew
		case flora
		case spindrift
	}
	
	enum BorderColor: Int {
		case redDark
		case orangeDark
		case yellowDark
		case limeDark
		case greenDark
		case mintDark
		case cyanDark
		case lightBlueDark
		case blueDark
		case purpleDark
		case pinkDark
		case dragonFruitDark
		case salmonDark
		case cantaloupeDark
		case bananaDark
		case honeydewDark
		case floraDark
		case spindriftDark
	}
}
