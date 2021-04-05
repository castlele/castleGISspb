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

	private lazy var mapPointView: MapPointView = {
		let view = MapPointView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
		view.translatesAutoresizingMaskIntoConstraints = false
		view.isOpaque = false
		addSubview(view)
		view.isHidden = true
		return view
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
}

// MARK:- Drawing the view
extension MapButtonView {

	override func draw(_ rect: CGRect) {
		backgroundColor = .clear

		if isActivated {
			animateMapPoint(isHidden: false)
			drawOpenedMap()
		} else {
			animateMapPoint(isHidden: true)
			drawClosedMap()
		}
	}

	private func animateMapPoint(isHidden: Bool) {
		if isHidden {
			UIView.animate(withDuration: 0.5) {
				self.mapPointView.isHidden = isHidden
				self.mapPointView.transform = CGAffineTransform.identity
			}
		} else {
			UIView.animate(withDuration: 0.5) {
				self.mapPointView.isHidden = isHidden
				self.mapPointView.transform = CGAffineTransform(translationX: self.STANDARD_SIZE / 3, y: self.STANDARD_SIZE / 5.5)
			}
		}
	}

	private func drawOpenedMap() {
		let openedMapPath = UIBezierPath()
		openedMapPath.move(to: pointsOfOpenedMap[0])
		drawFrameOf(map: openedMapPath, state: .opened)
		drawCurvedLine(state: .opened)
		setStroke(for: openedMapPath)
	}

	private func drawClosedMap() {
		let closedMapPath = UIBezierPath()
		closedMapPath.move(to: pointsOfClosedMap[0])
		drawFrameOf(map: closedMapPath, state: .closed)
		drawCurvedLine(state: .closed)
		drawDottedLine()
		setStroke(for: closedMapPath)
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
		path.lineWidth = 1.5
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

// MARK:- MapPointView 
class MapPointView: UIView {

	private var HEIGHT: CGFloat {
		frame.height
	}

	private var WIDTH: CGFloat {
		frame.width
	}

	private var ORIGIN: CGPoint {
		let x = WIDTH / 2
		let y = HEIGHT / 4

		return CGPoint(x: x, y: y)
	}

	private var RADIUS: CGFloat {
		WIDTH / 4 - 1
	}

	private let STROKE_WIDTH : CGFloat = 2
	
	override func draw(_ rect: CGRect) {
		drawCircle()
		drawBottom()
	}

	private func drawCircle() {
		let circlePath = UIBezierPath(
			arcCenter: ORIGIN, 
			radius: RADIUS, 
			startAngle: .pi, 
			endAngle: .pi * 4, 
			clockwise: true
		)
		UIColor.red.setStroke()
		circlePath.lineWidth = STROKE_WIDTH
		circlePath.stroke()
	}

	private func drawBottom() {
		let bottomPath = UIBezierPath()
		drawLeftCurveLine(for: bottomPath)
		drawRightCurveLine(for: bottomPath)
		closeBottomPath(for: bottomPath)

		UIColor.red.setFill()
		bottomPath.fill()
	}

	private func drawLeftCurveLine(for path: UIBezierPath) {
		let startPoint = CGPoint(x: ORIGIN.x - RADIUS - 3, y: ORIGIN.y + 3)
		let endPoint = CGPoint(x: ORIGIN.x, y: HEIGHT)

		path.move(to: startPoint)	
		path.addCurve(
			to: endPoint, 
			controlPoint1: CGPoint(x: WIDTH / 3, y: HEIGHT / 2 + HEIGHT / 6),
			controlPoint2: CGPoint(x: ORIGIN.x - 3, y: HEIGHT / 2 - 2 * HEIGHT / 6)
		) 
	}

	private func drawRightCurveLine(for path: UIBezierPath) {
		let startPoint = CGPoint(x: ORIGIN.x + RADIUS - 3, y: ORIGIN.y + 3)
		let endPoint = CGPoint(x: ORIGIN.x, y: HEIGHT)

		path.move(to: startPoint)	
		path.addCurve(
			to: endPoint, 
			controlPoint1: CGPoint(x: 2 * WIDTH / 3, y: HEIGHT / 2 + HEIGHT / 6),
			controlPoint2: CGPoint(x: ORIGIN.x + 3, y: HEIGHT / 2 - 2 * HEIGHT / 6)
		) 
	}

	private func closeBottomPath(for path: UIBezierPath) {
		let startPoint = CGPoint(x: ORIGIN.x - RADIUS - 3, y: ORIGIN.y + 3)
		let controlPoint = CGPoint(x: ORIGIN.x, y: ORIGIN.y + RADIUS)
		let endPoint = CGPoint(x: ORIGIN.x + RADIUS - 3, y: ORIGIN.y + 3)

		path.move(to: startPoint)
		path.addLine(to: controlPoint)
		path.addLine(to: endPoint)
	}
}
