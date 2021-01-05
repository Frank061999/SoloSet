//
//  Grid.swift
//  Practise 1 - Memorize
//
//  Created by Ardalan Owrangi on 7/11/20.
//  Copyright © 2020 Ardalan Owrangi. All rights reserved.
//

import SwiftUI

struct Grid<Item, ItemView>: View where Item: Identifiable, ItemView: View {
	private var items: Array<Item>
	private var viewForItem: (Item) -> ItemView
	init(_ items: [Item], viewForItem: @escaping (Item) -> ItemView){
		self.items=items
		self.viewForItem=viewForItem
	}
	var body: some View {
		GeometryReader { geometry in
			let layout = GridLayout(itemCount: items.count, nearAspectRatio: 2.5/3.5, in: geometry.size)
			ForEach(items){ item in
				viewForItem(item)
					.frame(width: layout.itemSize.width, height: layout.itemSize.height)
					.position(layout.location(ofItemAt: items.firstIndex(where: {$0.id == item.id})!))
			}
		}
	}
}

