import SwiftUI

struct VSection<C: View>: View {
	private let title: String
	private let content: C

	init(_ title: String, @ViewBuilder content: () -> C) {
		self.title = title
		self.content = content()
	}

	var body: some View {
		VStack(alignment: .leading) {
			Text(title)
				.font(.caption)
				.textCase(.uppercase)
				.foregroundStyle(.secondary)
				.padding(.horizontal)
			VStack {
				content
			}
			.padding(.horizontal)
		}
		.padding(.bottom)
	}
}
