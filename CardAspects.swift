//
//  CardAspects.swift
//  SoloSet
//
//  Created by Ardalan Owrangi on 1/5/21.
//

import Foundation
import SwiftUI

enum AspectShape: CaseIterable {
	case oval, squiggle, diamond
	@ViewBuilder
	func getShape()->some View{
		switch self {
		case .oval:
			AnyView(Oval())
		case .diamond:
			AnyView(Diamond())
		case .squiggle:
			AnyView(Squiggle())
		}
	}
}
enum AspectColor: CaseIterable {
	case red, purple, green
	func giveColor()-> Color{
		switch self {
		case .red: return Color.red
		case .purple: return Color.purple
		case.green: return Color.green
		}
	}
}
enum AspectNumber: CaseIterable {
	case one, two, three
	func intValue()->Int {
		switch self {
        case .one: return 1
		case .two: return 2
		case .three: return 3
		}
	}
}
enum AspectShading: CaseIterable {
	case solid, striped, outlined
}
