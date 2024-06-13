// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

private struct Showcase: View {
	var body: some View {
		TabView {
			Pickers()
			Sliders()
			Menus()
			Buttons()
			Labels()
		}
	}
}

#Preview {
	Showcase()
}
