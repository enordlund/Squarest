//
//  NavigationSheet.swift
//  Tuner
//
//  Created by Erik Nordlund on 7/6/20.
//  Copyright © 2020 Erik Nordlund. All rights reserved.
//

import SwiftUI

extension View {
	func navigationSheet(show: Binding<Bool>, title: String) -> some View {
		modifier(NavigationSheetModifier(isPresented: show, title: title))
	}
}

struct NavigationSheetModifier: ViewModifier {
	@Binding var isPresented: Bool
	
	let title: String
	
	func body(content: Content) -> some View {
		NavigationView {
			content
				.navigationBarTitle(Text(title))
				.navigationBarItems(trailing:
					Button(action: {
						self.dismissSelf()
						print("press")
					}) {
						SheetXButtonView()
					}
				)
				.edgesIgnoringSafeArea(.bottom)
		}
		
		
	}
	
	func dismissSelf() {
		isPresented = false
	}
}
