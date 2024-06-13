import SwiftUI

public struct FontPicker: View {
	@Binding var selection: String

	@Environment(\.dismiss) private var dismiss
	@State private var internalFontNames: [String] = []
	@State private var search = ""

	private var fontNames: [String] {
		if search.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
			return internalFontNames
		}
		return internalFontNames.filter { $0.contains(search) }
	}

	public init(selection: Binding<String>) {
		_selection = selection
	}

	public var body: some View {
		NavigationView {
			ScrollViewReader { reader in
				List {
					ForEach(fontNames, id: \.self) { fontName in
						Button {
							selection = fontName
							dismiss()
						} label: {
							Text(fontName)
								.font(.custom(fontName, size: 14))
								.lineLimit(1)
						}
						.tint(fontName == selection ? .accentColor : .primary)
						.id(fontName)
					}
				}
				.onChange(of: fontNames) { _ in
					reader.scrollTo(selection, anchor: .center)
				}
			}
			.navigationTitle("Fonts")
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					Button("Cancel") {
						dismiss()
					}
				}
			}
		}
		.navigationViewStyle(.stack)
		// https://sarunw.com/posts/always-show-search-bar-in-swiftui/
		.searchable(text: $search, placement: .navigationBarDrawer(displayMode: .always))
		.task {
			internalFontNames = UIFont.familyNames.sorted().flatMap {
				UIFont.fontNames(forFamilyName: $0)
			}
		}
	}
}
