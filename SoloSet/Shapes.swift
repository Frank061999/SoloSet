//
//  Shapes.swift
//  SoloSet
//
//  Created by Ardalan Owrangi on 1/7/21.
//

import SwiftUI

struct Diamond: Shape {
	func path(in rect: CGRect) -> Path {
		var path = Path()
		let width = rect.width * 0.80
		let height = width/2
		path.move(to: CGPoint(x:rect.midX-(width/2), y:rect.midY))
		path.addLine(to: CGPoint(x: rect.midX, y: rect.midY + (height/2)))
		path.addLine(to: CGPoint(x: rect.midX + (width/2), y: rect.midY))
		path.addLine(to: CGPoint(x: rect.midX, y: rect.midY - (height/2)))
		path.addLine(to: CGPoint(x: rect.midX - (width/2), y: rect.midY))
		return path
	}
}

struct Oval: Shape {
	func path(in rect: CGRect) -> Path {
		var path = Path()
		let height = (1/6) * rect.width
		let radius = height
		path.move(to: CGPoint(x: (rect.width / 6), y: rect.midY - radius))
		path.addArc(
			center: CGPoint(x: rect.width * (8/10), y: rect.midY),
			radius: radius,
			startAngle: Angle(degrees:270),
			endAngle: Angle(degrees:90),
			clockwise: false
		)
		path.addArc(
			center: CGPoint(x: rect.width * (2/10), y: rect.midY),
			radius: radius,
			startAngle: Angle(degrees:90),
			endAngle: Angle(degrees:270),
			clockwise: false
		)
		return path
	}
}

struct Squiggle: Shape {
	func path(in rect: CGRect) -> Path {
		var path = Path()
		let width = rect.width
		let height = width/3
		path.move(to: CGPoint(x: rect.maxX/10, y:rect.midY - (height/2)))
		path.addLine(to: CGPoint(x: rect.maxX*(9/10), y: rect.midY - (height/2)))
		path.addLine(to: CGPoint(x: rect.maxX*(9/10), y: rect.midY + height/2))
		path.addLine(to: CGPoint(x: rect.maxX/10, y: rect.midY + (height/2)))
		path.addLine(to: CGPoint(x: rect.maxX/10, y:rect.midY - (height/2)))
		return path
	}
	func striped(){
		
	}
}
struct StripView<T>: View where T: Shape {
	let numberOfStrips: Int = 7
	let lineWidth: CGFloat = 2
	let borderLineWidth: CGFloat = 1
	let color: Color
	let shape: T

	var body: some View {
		HStack(spacing: 0) {
			ForEach(0..<numberOfStrips) { number in
				Color.white
				color.frame(width: lineWidth)
				if number == numberOfStrips - 1 {
					Color.white
				}
			}

		}.mask(shape)
		.overlay(shape.stroke(color, lineWidth: borderLineWidth))
	}
}
struct WaveShape: Shape {
	func path(in rect: CGRect) -> Path {
		var path = Path()
		path.addEllipse(in: rect)
		return path
	}
}

struct Shapes_Previews: PreviewProvider {
	static var previews: some View {
		StripView(color: Color.green, shape: Diamond())
	}
}
