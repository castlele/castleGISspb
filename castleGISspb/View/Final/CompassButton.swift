//
//  CompassButton.swift
//  castleGISspb
//
//  Created by Nikita Semenov on 20.03.2021.
//

import UIKit

final class CompassButton: UIButton {
	
	private var ORIGIN : CGPoint {
		CGPoint(x: centerX, y: centerY)
	}
	
	private var centerX : CGFloat {
		frame.width / 2
	}
	
	private var centerY : CGFloat {
		frame.height / 2
	}
	
	private var SIZE : CGSize {
		CGSize(width: WIDTH, height: HEIGHT)
	}
	
	private var WIDTH : CGFloat {
		bounds.width
	}
	
	private var HEIGHT : CGFloat {
		bounds.height
	}
	
	private let STROKE_WIDTH : CGFloat = 2.5
	
	private var RADIUS : CGFloat {
		bounds.width / 2 - 4
	}
	
	private var ARROW_BASE_WIDTH : CGFloat {
		WIDTH / 4
	}
	
	private struct Colors {
		
		static let strokeColor : UIColor = .white
		static let baseColor : UIColor = .black
		static let nArrowColor : UIColor = .red
		static let sArrowColor : UIColor = .white
	}
	
	private enum ArrowType: CaseIterable {
		case north
		case south
	}
	
	// MARK:- draw(_ rect: CGRect)
	override func draw(_ rect: CGRect) {
		drawBase()
		drawArrows()
    }
	
	private func drawBase() {
		let basePath = UIBezierPath(arcCenter: ORIGIN, radius: RADIUS, startAngle: .pi, endAngle: .pi * 4, clockwise: true)
		
		Colors.baseColor.withAlphaComponent(0.6).setFill()
		Colors.strokeColor.withAlphaComponent(0.9).setStroke()
		basePath.lineWidth = STROKE_WIDTH
		
		basePath.fill()
		basePath.stroke()
	}
	
	private func drawArrows() {
		for arrow in ArrowType.allCases {
			drawArrow(arrow)
		}
	}
	
	private func drawArrow(_ arrow: ArrowType) {
		var (startPoint, topPoint, endPoint) : (start: CGPoint, top: CGPoint, end: CGPoint)
		var fillColor : UIColor
		switch arrow {
			case .north:
				(startPoint, topPoint, endPoint) = getArrowCoordinates(for: .north, withBase: ARROW_BASE_WIDTH)
				fillColor = Colors.nArrowColor.withAlphaComponent(0.85)
			case .south:
				(startPoint, topPoint, endPoint) = getArrowCoordinates(for: .south, withBase: ARROW_BASE_WIDTH)
				fillColor = Colors.sArrowColor.withAlphaComponent(0.85)
		}
		
		let arrowPath = UIBezierPath()
		
		arrowPath.move(to: startPoint)
		arrowPath.addLine(to: topPoint)
		arrowPath.addLine(to: endPoint)
		
		arrowPath.close()
		
		fillColor.setFill()
		arrowPath.fill()
	}
	
	private func getArrowCoordinates(for arrow: ArrowType, withBase arrowBaseWidth: CGFloat) -> (start: CGPoint, top: CGPoint, end: CGPoint) {
		let startPoint = CGPoint(x: ORIGIN.x - (arrowBaseWidth / 2), y: ORIGIN.y)
		let endPoint = CGPoint(x: ORIGIN.x + (arrowBaseWidth / 2), y: ORIGIN.y)
		var topPoint : CGPoint
		
		switch arrow {
			case .north:
				topPoint = CGPoint(x: ORIGIN.x, y: ORIGIN.y - (HEIGHT / 2 - 4))
			case .south:
				topPoint = CGPoint(x: ORIGIN.x, y: ORIGIN.y + (HEIGHT / 2 - 4))
		}
		
		return (startPoint, topPoint, endPoint)
	}
}
