//
//  Measurements.swift
//  castleGISspb
//
//  Created by Nikita Semenov on 12.03.2021.
//

import UIKit

struct Measurements {
	
	private static let CORNER_RADIUS : CGFloat = 20
	private static let BUTTON_HEIGHT : CGFloat = 30
	private static let BUTTON_WIDTH : CGFloat = 50
	private static let BUTTON_SIZE : CGFloat = 60

	private static let PADDING : CGFloat = 10
	private static let PADDING_BETWEEN_VIEWS : CGFloat = 40
	private static let PADDING_FROM_BOTTOM_MARGIN : CGFloat = -30
	
	static func getCornerRaduis() -> CGFloat {
		CORNER_RADIUS
	}
	
	static func getStandardButtonHeight() -> CGFloat {
		BUTTON_HEIGHT
	}
	
	static func getStandardButtonWidth() -> CGFloat {
		BUTTON_WIDTH
	}
	
	static func getStandardButtonSize() -> CGFloat {
		BUTTON_SIZE
	}
	
	static func getPadding() -> CGFloat {
		PADDING
	}
	
	static func getPaddingBetweenViews() -> CGFloat {
		PADDING_BETWEEN_VIEWS
	}
	
	static func getPaddingFromBottomMargin() -> CGFloat {
		PADDING_FROM_BOTTOM_MARGIN
	}
}
