import SwiftUI

struct Labels: View {
	var body: some View {
		PageLayoutView("Labels", icon: .systemTextformatAlt) {
			ScrollView(.vertical) {
				VStack {
					HScrollSection("Primary") {
						ActionLabel("Label")
						ActionLabel("Label", icon: .systemPlus)
						ActionLabel("Label", loading: true)
						ActionLabel("Label", icon: .systemTrash, role: .destructive)
					}
					HScrollSection("Primary Large") {
						ActionLabel("Label", variant: .primaryLarge)
						ActionLabel("Label", icon: .systemPlus, variant: .primaryLarge)
						ActionLabel("Label", variant: .primaryLarge, loading: true)
						ActionLabel("Label", icon: .systemTrash, variant: .primaryLarge, role: .destructive)
					}
					HScrollSection("Secondary") {
						ActionLabel("Label", variant: .secondary)
						ActionLabel("Label", icon: .systemPlus, variant: .secondary)
						ActionLabel("Label", variant: .secondary, loading: true)
						ActionLabel("Label", icon: .systemTrash, variant: .secondary, role: .destructive)
					}
					HScrollSection("Secondary Large") {
						ActionLabel("Label", variant: .secondaryLarge)
						ActionLabel("Label", icon: .systemPlus, variant: .secondaryLarge)
						ActionLabel("Label", variant: .secondaryLarge, loading: true)
						ActionLabel("Label", icon: .systemTrash, variant: .secondaryLarge, role: .destructive)
					}
					HScrollSection("Circle Label") {
						CircleLabel(.systemPlus)
						CircleLabel(.systemPlus, loading: true)
						CircleLabel(.systemPlus, variant: .small)
						CircleLabel(.systemPlus, variant: .small, loading: true)
					}
					HScrollSection("Caption Label") {
						CaptionLabel("Caption")
						CaptionLabel("Caption", icon: .systemPlus)
						CaptionLabel("Caption", icon: .systemPlus, loading: true)
						CaptionLabel("Caption", titleWidth: 100)
					}
					HScrollSection("Tool Label") {
						ToolLabel("Label", icon: .systemPlus)
						ToolLabel("Label", icon: .systemPlus, loading: true)
						ToolLabel("Label", icon: .systemPlus, focused: true)
					}
				}
				.padding(.top, 56)
			}
		}
		.tabItem {
			Label("Labels", systemImage: "textformat.alt")
		}
	}
}
