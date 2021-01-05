//
//  Model.swift
//  SoloSet
//
//  Created by Ardalan Owrangi on 1/5/21.
//

import Foundation
struct SoloSetGame {
	private static let allCards: [Card] = generateNewDeck()
	var matchedCards: Array<Card> = []
	var matchedCardIndecies: Array<Int> = []
	var deck: Array<Card> = []
	var table: Array<Card>!
	var matchState: Bool {
		if selectedCardIndecies.count != 3 {return false}
		if table[selectedCardIndecies[0]].isMatched && table[selectedCardIndecies[1]].isMatched && table[selectedCardIndecies[2]].isMatched {
			return true
		} else {return false}
	}
	var maxSelection: Bool {
		return selectedCardIndecies.count == 3
	}
	private func isMatched(isTryingtoCheat: Bool) -> Bool {
		if selectedCardIndecies.count == 3 || isTryingtoCheat {
			var shapeState: Bool
			var colorState: Bool
			var numberState: Bool
			var shadingState: Bool
			if table[selectedCardIndecies[0]].shape == table[selectedCardIndecies[1]].shape
				&& table[selectedCardIndecies[1]].shape == table[selectedCardIndecies[2]].shape {
				shapeState = true
			} else if table[selectedCardIndecies[0]].shape != table[selectedCardIndecies[1]].shape &&
						table[selectedCardIndecies[1]].shape != table[selectedCardIndecies[2]].shape && table[selectedCardIndecies[0]].shape != table[selectedCardIndecies[2]].shape {
				shapeState = true
			} else {
				shapeState = false
			}
			if table[selectedCardIndecies[0]].color == table[selectedCardIndecies[1]].color
				&& table[selectedCardIndecies[1]].color == table[selectedCardIndecies[2]].color {
				colorState = true
			} else if table[selectedCardIndecies[0]].color != table[selectedCardIndecies[1]].color &&
						table[selectedCardIndecies[1]].color != table[selectedCardIndecies[2]].color && table[selectedCardIndecies[0]].color != table[selectedCardIndecies[2]].color {
				colorState = true
			} else {
				colorState = false
			}
			if table[selectedCardIndecies[0]].number == table[selectedCardIndecies[1]].number
				&& table[selectedCardIndecies[1]].number == table[selectedCardIndecies[2]].number {
				numberState = true
			} else if table[selectedCardIndecies[0]].number != table[selectedCardIndecies[1]].number &&
						table[selectedCardIndecies[1]].number != table[selectedCardIndecies[2]].number && table[selectedCardIndecies[0]].number != table[selectedCardIndecies[2]].number {
				numberState = true
			} else {
				numberState = false
			}
			if table[selectedCardIndecies[0]].shading == table[selectedCardIndecies[1]].shading
				&& table[selectedCardIndecies[1]].shading == table[selectedCardIndecies[2]].shading {
				shadingState = true
			} else if table[selectedCardIndecies[0]].shading != table[selectedCardIndecies[1]].shading &&
						table[selectedCardIndecies[1]].shading != table[selectedCardIndecies[2]].shading && table[selectedCardIndecies[0]].shading != table[selectedCardIndecies[2]].shading {
				shadingState = true
			} else {
				shadingState = false
			}
			return shadingState && colorState && numberState && shapeState
		}
		return false
	}
	
	var selectedCardIndecies: Array<Int>!{
		didSet {
			if isMatched(isTryingtoCheat: false){
				for index in selectedCardIndecies {
					table[index].isMatched=true
				}
			}
		}
	}
	mutating private func removeMatchedCards(){
		print("REMOVING CARDS")
		if table.count == 12 && deck.isEmpty {
			for i in (0..<table.count).reversed(){
				if table[i].isMatched {
					matchedCards.append(table[i])
					table.remove(at: i)
				}
			}
		}
		for i in (0..<table.count).reversed(){
			if table[i].isMatched {
				matchedCards.append(table[i])
				table[i].isEmpty = true
			}
		}
		selectedCardIndecies.removeAll()
		if !(table.count>12) {
			deal(isFirstTime: false)
		} else { removeEmptyCards() }
	}
	init(){
		deck = SoloSetGame.allCards.shuffled()
		selectedCardIndecies = [	]
		table = [ ]
	}
	private mutating func removeEmptyCards(){
		for i in table.indices.reversed(){
			if table[i].isEmpty{
				table.remove(at: i)
			}
		}
	}
	mutating func choose(card: Card){
		if card.isMatched {
			removeMatchedCards()
			return
		}
		if let index = table.firstIndex(of: card) {
			//if player made a match:
			if !table[index].isChosen && selectedCardIndecies.count == 3 && matchState{
				removeMatchedCards()
				selectedCardIndecies.append(table.firstIndex(of: card)!)
			}
			//if player didn't make a match
			else if !table[index].isChosen && selectedCardIndecies.count == 3 {
				selectedCardIndecies.forEach({table[$0].isChosen=false})
				selectedCardIndecies.removeAll()
				selectedCardIndecies.append(table.firstIndex{shart in shart.id==card.id}!)
			}
			//selecting card for the first time:
			else if !table[index].isChosen {
				selectedCardIndecies.append(index)
			}
			//if an already chosen card is selected, remove it from the selected cards array:
			else {
				selectedCardIndecies.remove(at: selectedCardIndecies.firstIndex(of: table.firstIndex(of: card)!)!)
			}
			table[table.firstIndex{$0.id==card.id}!].isChosen.toggle()
			var k: String = "selected cards:"
			for index in selectedCardIndecies{
				k.append(" \(index), ")
			}
			print(k)
            print("card chosen: \(card.content) + ")
		}
	}
	mutating func deal(isFirstTime: Bool){
		if isFirstTime {
			for _ in 0..<12 {
				table.append(deck.popLast()!)
			}
		} else {
			mainLoop: for _ in 0..<3 {
				if let lastCard = deck.popLast() {
					for i in table.indices {
						if table[i].isEmpty {
							table[i] = lastCard
							continue mainLoop
						}
					}
				} else {
					return
				}
			}
		}
	}
	mutating func add3MoreCards(){
		if deck.isEmpty { return }
		for _ in 0..<3 {
			table.append(deck.popLast()!)
		}
	}
	mutating func cheat() {
		let cache = selectedCardIndecies
		selectedCardIndecies.removeAll()
		for i in table {
			for j in table[1...] {
				for k in table[2...] {
					if i==j || j==k || i==k {continue}
					if i.cheatMatch || j.cheatMatch || k.cheatMatch {continue}
					let a=table.firstIndex(where: {$0.id==i.id})!
					let b=table.firstIndex(where: {$0.id==j.id})!
					let c=table.firstIndex(where: {$0.id==k.id})!
					selectedCardIndecies = [a,b,c,-1]
					if isMatched(isTryingtoCheat: true) {
						for index in selectedCardIndecies[...2]{
							table[index].cheatMatch = true
						}
						selectedCardIndecies = cache
						return
					}
				}
			}
		}
		selectedCardIndecies = cache
	}
	struct Card: Equatable, Identifiable {
		var isEmpty: Bool = false
		var isChosen: Bool = false
		var isMatched: Bool = false
		var cheatMatch: Bool = false
		let shape: AspectShape
		let color: AspectColor
		let number: AspectNumber
		let shading: AspectShading
		let id: Int
		var content: String { return "Shape: \(shape), Color: \(color), Number: \(number), Shading: \(shading), isEmpty: \(isEmpty), isChosen: \(isChosen), isMatched: \(isMatched) " }
		//, isDealt: \(isEmpty), isChosen: \(isChosen), isMatched: \(isMatched)
	}
    static var currentID: Int = 0
	private static func generateNewDeck () -> Array<Card> {
		var array: Array<Card> = []
		for shapes in AspectShape.allCases {
			for colors in AspectColor.allCases {
				for numbers in AspectNumber.allCases {
					for shadings in AspectShading.allCases {
						array.append(
							Card(
                                shape: shapes,
								color: colors,
								number: numbers,
								shading: shadings,
//								id: Int.random(in: 0...Int.max)
                                id: currentID
							)
                        )
                        currentID += 1
					}
				}
			}
		}
		print("generateNewDeck has been executed.")
		return array
	}
}
