import SwiftUI

struct Menus: View {
	var body: some View {
		PageLayoutView("Menus", icon: .systemFilemenuAndSelection) {
			ScrollView {
				VStack {
					HScrollSection("Primary") {
						ActionMenu("Menu") { dummyMenu() }
						ActionMenu("Menu", icon: .systemPlus) { dummyMenu() }
						ActionMenu("Menu", loading: true) { dummyMenu() }
						ActionMenu("Menu", icon: .systemTrash, role: .destructive) { dummyMenu() }
					}
					HScrollSection("Primary Large") {
						ActionMenu("Menu", variant: .primaryLarge) { dummyMenu() }
						ActionMenu("Menu", icon: .systemPlus, variant: .primaryLarge) { dummyMenu() }
						ActionMenu("Menu", variant: .primaryLarge, loading: true) { dummyMenu() }
						ActionMenu("Menu", icon: .systemTrash, variant: .primaryLarge, role: .destructive) { dummyMenu() }
					}
					HScrollSection("Secondary") {
						ActionMenu("Menu", variant: .secondary) { dummyMenu() }
						ActionMenu("Menu", icon: .systemPlus, variant: .secondary) { dummyMenu() }
						ActionMenu("Menu", variant: .secondary, loading: true) { dummyMenu() }
						ActionMenu("Menu", icon: .systemTrash, variant: .secondary, role: .destructive) { dummyMenu() }
					}
					HScrollSection("Secondary Large") {
						ActionMenu("Menu", variant: .secondaryLarge) { dummyMenu() }
						ActionMenu("Menu", icon: .systemPlus, variant: .secondaryLarge) { dummyMenu() }
						ActionMenu("Menu", variant: .secondaryLarge, loading: true) { dummyMenu() }
						ActionMenu("Menu", icon: .systemTrash, variant: .secondaryLarge, role: .destructive) { dummyMenu() }
					}
					HScrollSection("Circle Menu") {
						CircleMenu(.systemPlus) { dummyMenu() }
						CircleMenu(.systemPlus, loading: true) { dummyMenu() }
						CircleMenu(.systemPlus, variant: .small) { dummyMenu() }
						CircleMenu(.systemPlus, variant: .small, loading: true) { dummyMenu() }
					}
					HScrollSection("Caption Menu") {
						CaptionMenu("Menu") { dummyMenu() }
						CaptionMenu("Menu", icon: .systemPlus) { dummyMenu() }
						CaptionMenu("Menu", loading: true) { dummyMenu() }
						CaptionMenu("Menu", titleWidth: 100) { dummyMenu() }
					}
					HScrollSection("Tool Menu") {
						ToolMenu("Menu", icon: .systemPlus) { dummyMenu() }
						ToolMenu("Menu", icon: .systemPlus, loading: true) { dummyMenu() }
						ToolMenu("Menu", icon: .systemPlus, focused: true) { dummyMenu() }
					}
				}
				.padding(.top, 56)
			}
		}
		.tabItem {
			Label("Menus", systemImage: "filemenu.and.selection")
		}
	}

	@ViewBuilder func dummyMenu() -> some View {
		Button {} label: {
			Image.systemSquareAndArrowUp
			Text("Save")
		}
		Button {} label: {
			Image.systemTextCursor
			Text("Edit")
		}
		Button(role: .destructive) {} label: {
			Image.systemTrash
			Text("Remove")
		}
	}
}
