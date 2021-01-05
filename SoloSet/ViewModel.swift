//
//  ViewModel.swift
//  SoloSet
//
//  Created by Ardalan Owrangi on 1/5/21.
//

import SwiftUI

class ViewModel: ObservableObject {
	@Published private var model = SoloSetGame()
	// MARK: - Acess to the model
	var deck: Array<SoloSetGame.Card>{
		return model.deck
	}
	var table: Array<SoloSetGame.Card>{
		return model.table
	}
	var matchState: Bool{
		model.matchState
	}
	var maxSelection: Bool {
		model.maxSelection
	}
	var numberOfCardLeftInGame: Int {
		model.deck.count + model.table.count
	}
	// MARK: - Intent(s)
	func choose(card: SoloSetGame.Card){
		model.choose(card: card)
	}
	func cheat(){
		model.cheat()
	}
	func deal(){
		model.add3MoreCards()
	}
	func newGame(){
		model = SoloSetGame()
		startGame()
	}
    func removeAllCards(){
        model.deck.removeAll()
        model.table.removeAll()
    }
	func startGame(){
		model.deal(isFirstTime: true)
	}
}
