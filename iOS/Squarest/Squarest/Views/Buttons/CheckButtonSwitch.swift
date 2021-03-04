//
//  CheckButton.swift
//  Tuner
//
//  Created by Erik Nordlund on 7/1/20.
//  Copyright © 2020 Erik Nordlund. All rights reserved.
//

import SwiftUI

struct CheckButtonSwitch: View {
	
	let index: Int
	@Binding var selectedIndex: Int
	
	@Binding var isExpanded: Bool
	
	init(index: Int, selectedIndex: Binding<Int>, isExpanded: Binding<Bool>?) {
		self.index = index
		self._selectedIndex = selectedIndex
		
		if isExpanded != nil {
			self._isExpanded = isExpanded!
		} else {
			self._isExpanded = Binding.constant(true)
		}
		
	}
	
	var body: some View {
		Button(action: {
			withAnimation {
				isExpanded = false
			}
			
			selectedIndex = index
		}, label: {
			if selectedIndex == index {
				Image(systemName: "checkmark.circle.fill")
					.font(Font.title3.weight(.regular))
			} else {
				Image(systemName: "circle")
					.font(Font.title3.weight(.light))
					.accentColor(Color(.systemGray2))
			}
		})
	}
}

struct CheckButtonSwitch_Previews: PreviewProvider {
	
	@State static var selected = 0
	@State static var expanded: Bool = true
	
	static var previews: some View {
		CheckButtonSwitch(index: 0, selectedIndex: $selected, isExpanded: $expanded)
	}
}
