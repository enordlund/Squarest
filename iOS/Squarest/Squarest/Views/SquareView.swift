//
//  SquareView.swift
//  Squarest
//
//  Created by Erik Nordlund on 7/8/20.
//

import SwiftUI

struct SquareView: View {
	@State var squareInput: String = ""
	
	@StateObject var squarer = Squarer()
	
	var body: some View {
		NavigationView {
			VStack {
				Spacer()
				Group {
					if squarer.isLoading {
						// result is loading
						ProgressView()
					} else {
						// request is complete, with possible error
						if squarer.errorMessage != nil {
							Text(squarer.errorMessage!)
						} else if squarer.result != nil {
							Text(squarer.result!)
						} else {
							Text("Please enter a number.")
						}
					}
				}
				.padding()
				
				
				TextField("Value", text: $squareInput)
					.textFieldStyle(RoundedBorderTextFieldStyle())
				
				Button("Get Square", action: {
					squarer.requestSquare(of: squareInput)
				})
				.padding()
                Spacer()
			}
			.navigationBarTitle(Text("Square"), displayMode: .large)
			.padding()
		}
        
	}
}

struct SquareView_Previews: PreviewProvider {
    static var previews: some View {
        SquareView()
    }
}
