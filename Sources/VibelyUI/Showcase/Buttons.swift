import SwiftUI

struct Buttons: View {
	var body: some View {
		PageLayoutView("Buttons", icon: .systemCursorArrowRays) {
			ScrollView {
				VStack {
					HScrollSection("Primary") {
						ActionButton("Button") {}
						ActionButton("Button", icon: .systemPlus) {}
						ActionButton("Button", loading: true) {}
						ActionButton("Button", icon: .systemTrash, role: .destructive) {}
					}
					HScrollSection("Primary Large") {
						ActionButton("Button", variant: .primaryLarge) {}
						ActionButton("Button", icon: .systemPlus, variant: .primaryLarge) {}
						ActionButton("Button", variant: .primaryLarge, loading: true) {}
						ActionButton("Button", icon: .systemTrash, variant: .primaryLarge, role: .destructive) {}
					}
					HScrollSection("Secondary") {
						ActionButton("Button", variant: .secondary) {}
						ActionButton("Button", icon: .systemPlus, variant: .secondary) {}
						ActionButton("Button", variant: .secondary, loading: true) {}
						ActionButton("Button", icon: .systemTrash, variant: .secondary, role: .destructive) {}
					}
					HScrollSection("Secondary Large") {
						ActionButton("Button", variant: .secondaryLarge) {}
						ActionButton("Button", icon: .systemPlus, variant: .secondaryLarge) {}
						ActionButton("Button", variant: .secondaryLarge, loading: true) {}
						ActionButton("Button", icon: .systemTrash, variant: .secondaryLarge, role: .destructive) {}
					}
					HScrollSection("Circle Button") {
						CircleButton(.systemPlus) {}
						CircleButton(.systemPlus, loading: true) {}
						CircleButton(.systemPlus, role: .destructive) {}
						CircleButton(.systemPlus, variant: .small) {}
						CircleButton(.systemPlus, variant: .small, loading: true) {}
						CircleButton(.systemPlus, variant: .small, role: .destructive) {}
					}
					HScrollSection("Caption Button") {
						CaptionButton("Button") {}
						CaptionButton("Button", icon: .systemPlus) {}
						CaptionButton("Button", icon: .systemPlus, loading: true) {}
						CaptionButton("Button", icon: .systemPlus, role: .destructive) {}
						CaptionButton("Button", icon: .systemPlus, titleWidth: 100) {}
					}
					HScrollSection("Tool Button") {
						ToolButton("Button", icon: .systemPlus) {}
						ToolButton("Button", icon: .systemPlus, loading: true) {}
						ToolButton("Button", icon: .systemPlus, focused: true) {}
						ToolButton("Button", icon: .systemPlus, role: .destructive) {}
					}
				}
				.padding(.top, 56)
			}
		}
		.tabItem {
			Label("Buttons", systemImage: "cursorarrow.rays")
		}
	}
}
