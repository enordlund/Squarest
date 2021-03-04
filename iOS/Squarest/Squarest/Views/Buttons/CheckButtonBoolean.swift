//
//  CheckButton.swift
//  Tuner
//
//  Created by Erik Nordlund on 7/1/20.
//  Copyright © 2020 Erik Nordlund. All rights reserved.
//

import SwiftUI

struct CheckButtonBoolean: View {
	
	@Binding var isSelected: Bool
	
	var action: () -> Void
	
	init(isSelected: Binding<Bool>, action: @escaping () -> Void) {
		self._isSelected = isSelected
		self.action = action
	}
	
	var body: some View {
		Button(action: {
			isSelected.toggle()
			action()
		}, label: {
			if isSelected {
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

struct CheckButtonBoolean_Previews: PreviewProvider {
	
	@State static var selected = true
	
	static var previews: some View {
		CheckButtonBoolean(isSelected: $selected, action: {
			
		})
	}
}
