//
//  MqpButtonView.swift
//  castleGISspb
//
//  Created by Nikita Semenov on 01.04.2021.
//

import UIKit
import FancyTabBarController

final class MapButtonView: UIButton, TabBarItem {

	private let STANDARD_SIZE : CGFloat = 30

	private enum State {
		case opened
		case closed
	}

	private lazy var pointsOfClosedMap: [CGPoint] = {
		[
			CGPoint(x: 1, y: STANDARD_SIZE - 1),
			CGPoint(x: STANDARD_SIZE - 1, y: STANDARD_SIZE - 1),
			CGPoint(x: STANDARD_SIZE - 1, y: 1),
			CGPoint(x: 1, y: 1)
		]
	}()

	private lazy var closedMapAttributePoints: (dottedLine: [CGPoint], curveLine: [CGPoint]) = {
		let partOfFrame = STANDARD_SIZE / 3
		let dottedLine = [
			CGPoint(x: 1, y: 10),
			CGPoint(x: partOfFrame, y: 13),
			CGPoint(x: partOfFrame * 2, y: 7),
			CGPoint(x: STANDARD_SIZE - 1, y: 6)
		]

		let curveLine = [
			CGPoint(x: partOfFrame - 3, y: 1),
			CGPoint(x: partOfFrame - 3, y: partOfFrame),
			CGPoint(x: (partOfFrame * 2) + 3, y: partOfFrame * 2),
			CGPoint(x: (partOfFrame * 2) + 3, y: STANDARD_SIZE - 1)
		]

		return (dottedLine, curveLine)
	}()

	private lazy var pointsOfOpenedMap: [CGPoint] = {
		[
			CGPoint(x: 1, y: STANDARD_SIZE - 1),
			CGPoint(x: STANDARD_SIZE - 1, y: STANDARD_SIZE - 1),
			CGPoint(x: STANDARD_SIZE - 6, y: 0),
			CGPoint(x: 6, y: 0)
		]
	}()

	private lazy var curvedLinePointsOfOpenedMap: [CGPoint] = {
		let partOfFrame = STANDARD_SIZE / 3
		let points = [
			CGPoint(x: 10, y: 0),
			CGPoint(x: 10, y: 10),
			CGPoint(x: STANDARD_SIZE - 10, y: partOfFrame * 2),
			CGPoint(x: STANDARD_SIZE - 10, y: STANDARD_SIZE - 1)
		]
		return points
	}()

	var isActivated: Bool = false
	
	override required init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder: NSCoder) {
		fatalError()
	}
	
	convenience init() {
		let standardFrame = CGRect(
			x: 0, 
			y: 0, 
			width: 30,
			height: 30
		)
		self.init(frame: standardFrame)
		
		translatesAutoresizingMaskIntoConstraints = false
	}

	override func draw(_ rect: CGRect) {
		backgroundColor = .clear

		if isActivated {
			drawOpenedMap()
		} else {
			drawClosedMap()
		}
	}

	private func drawOpenedMap() {
		let openedMapPath = UIBezierPath()
		openedMapPath.move(to: pointsOfOpenedMap[0])
//		addAnimation(for: "\(openedMapPath)")
		drawFrameOf(map: openedMapPath, state: .opened)
		drawCurvedLine(state: .opened)
		setStroke(for: openedMapPath)
	}

	private func drawClosedMap() {
		let closedMapPath = UIBezierPath()
		closedMapPath.move(to: pointsOfClosedMap[0])
//		addAnimation(for: "\(closedMapPath)")
		drawFrameOf(map: closedMapPath, state: .closed)
		drawCurvedLine(state: .closed)
		drawDottedLine()
		setStroke(for: closedMapPath)
	}
	
	private func addAnimation(for keyPath: String) {
		let shapeLayer = CAShapeLayer()
		layer.addSublayer(shapeLayer)
		
		let animation = CABasicAnimation(keyPath: keyPath)
		animation.fromValue = 0
		animation.toValue = 1
		animation.duration = 0.5
		shapeLayer.add(animation, forKey: nil)
	}

	private func drawFrameOf(map path: UIBezierPath, state: State) {
		switch state {
			case .opened:
				drawLinesOfFrame(for: path, in: pointsOfOpenedMap)
				path.addLine(to: pointsOfOpenedMap[0])
				path.addLine(to: pointsOfOpenedMap[1])
			case .closed:
				drawLinesOfFrame(for: path, in: pointsOfClosedMap)
				path.addLine(to: pointsOfClosedMap[0])
				path.addLine(to: pointsOfClosedMap[1])
		}
	}

	private func drawLinesOfFrame(for path: UIBezierPath, in arrayOfPoints: [CGPoint]) {
		for point in arrayOfPoints {
			if point != arrayOfPoints.first {
				path.addLine(to: point)
			}
		}
	}

	private func setStroke(for path: UIBezierPath) {
		path.lineWidth = 1
		path.lineJoinStyle = .round
		ColorPicker.getSubAccentColor().setStroke()
		path.stroke()
	}

	private func drawCurvedLine(state: State) {
		let path = UIBezierPath()

		switch state {
			case .opened:
				path.move(to: curvedLinePointsOfOpenedMap[0])
				path.addCurve(
					to: curvedLinePointsOfOpenedMap[3], 
					controlPoint1: curvedLinePointsOfOpenedMap[1],
					controlPoint2: curvedLinePointsOfOpenedMap[2]
				) 
			case .closed:
				let curvedLine = closedMapAttributePoints.curveLine

				path.move(to: curvedLine[0])
				path.addCurve(
					to: curvedLine[3], 
					controlPoint1: curvedLine[1],
					controlPoint2: curvedLine[2]
				) 
		}

		setStroke(for: path)
	}

	private func drawDottedLine() {
		let path = UIBezierPath()

		let dottedLine = closedMapAttributePoints.dottedLine

		path.move(to: dottedLine[0])
		path.addCurve(
			to: dottedLine[3], 
			controlPoint1: dottedLine[1],
			controlPoint2: dottedLine[2]
		) 
		path.setLineDash([2.5], count: 1, phase: 0)
		setStroke(for: path)
	}
}
