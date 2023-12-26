//
//  ContentView.swift
//  SoloSet
//
//  Created by Ardalan Owrangi on 1/5/21.
//

import SwiftUI

struct ContentView: View {
	@ObservedObject var viewModel: ViewModel = ViewModel()
	var body: some View {
		VStack {
			HStack {
				Image("cheat").onTapGesture {
					withAnimation(.linear(duration:2)){viewModel.cheat()}
				}.frame(alignment: .leading)
				Spacer()
				Button("Deal", action: withAnimation(.linear(duration:2)){viewModel.deal})
					.padding(.leading).padding(.leading).padding(.leading)

				Spacer()
				Spacer()
				Button("New Game", action: withAnimation{viewModel.newGame})
				Spacer()
				Text("Cards left in game: \(viewModel.numberOfCardLeftInGame)")
			}.padding()
			GeometryReader { mainSize in
				Grid(viewModel.table) { card in
					GeometryReader { geometry in
						if !card.isEmpty{
							CardView(color: getCardColor(card: card), size: geometry.size, card: card)
							.rotation3DEffect(card.isMatched ? Angle.degrees(180): Angle.degrees(0), axis: (x: 0, y: 1, z: 0))
							.padding(5)
							.onTapGesture{
								withAnimation(.easeInOut(duration:0.8))
									{viewModel.choose(card: card)}
							}.transition(.asymmetric(
											insertion: AnyTransition.offset(flyAway(size: mainSize.size)),
											removal: AnyTransition.offset(flyAway(size: mainSize.size))
												.combined(with:.flipAway).animation(.linear(duration:0.65))))
						}
					}
					.foregroundColor(card.isChosen ? Color.yellow : Color.black)
					.transition(.asymmetric(
						insertion: AnyTransition.offset(flyAway(size: mainSize.size)),
						removal: AnyTransition.offset(flyAway(size: mainSize.size))
							.combined(with:.flipAway).animation(.linear(duration:0.65))
					)
					)
				}
			}
		}.onAppear(){
			withAnimation(.linear(duration:1.5)){
				viewModel.newGame()
			}
		}
	}
	let cornerRadius: CGFloat = 10
	let edgeLineWidth: CGFloat = 5
	@ViewBuilder
	func CardView(color: Color, size: CGSize, card: SoloSetGame.Card)-> some View {
		Group {
			RoundedRectangle(cornerRadius:cornerRadius).fill(color)
			RoundedRectangle(cornerRadius:cornerRadius).stroke(lineWidth: edgeLineWidth).transition(.opacity)
			VStack {
				ForEach(Range<Int>(1...card.number.intValue())) { val in
					switch card.shape{
                        case .squiggle:
                        switch card.shading{
                                case .outlined: Squiggle().stroke(lineWidth: 3)
                                case .solid: Squiggle().fill()
                                case .striped: StripView(color: card.color.giveColor(), shape: Squiggle())
                            }
                            
                        case .diamond:
                            switch card.shading{
                                case .outlined: Diamond().stroke(lineWidth: 3)
                                case .solid: Diamond().fill()
                                case .striped: StripView(color: card.color.giveColor(), shape: Diamond())
                            }
                            
                        case .oval:
                            switch card.shading{
                                case .outlined: Oval().stroke(lineWidth: 2)
                                case .solid: Oval().fill()
                                case .striped: StripView(color: card.color.giveColor(), shape: Oval())
                            }
						
					}
				}.foregroundColor(card.color.giveColor())
			}.padding(5)
		}.animation(.linear)
	}
	func getCardColor(card: SoloSetGame.Card) -> Color {
		if card.isMatched {return Color.green}
		else if card.isChosen && viewModel.maxSelection {
			return Color.red
		} else if card.cheatMatch {return Color.yellow}
		else {return Color.white}
	}
	func flyAway(size: CGSize) -> CGSize {
		let boolWidth = Bool.random()
		let boolHeight = Bool.random()
		return CGSize(
			width: CGFloat.random(in: boolWidth ? (size.width)...(size.width*2) : -(size.width*2)...(0)),
			height: CGFloat.random(in: boolHeight ? (size.height)...(size.height*2) : -(size.height*2)...(0))
		)
	}
	
}

extension AnyTransition {
	static var flipAway: AnyTransition {
		.modifier(
			active: RotatingModifier(angle: 360),
			identity: RotatingModifier(angle: 0)
		)
	}
}
struct RotatingModifier: ViewModifier {
	var angle: Double
	func body(content: Content) -> some View {
		content.rotation3DEffect(Angle.degrees(angle), axis: (x: 0, y: 1, z: 0))
	}
}
struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
			
	}
}
