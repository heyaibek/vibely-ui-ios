import SwiftUI

public struct PageLayoutView<C, L, T, F>: View where C: View, L: View, T: View, F: View {
	private let title: String
	private let icon: Image?
	private let content: C
	private let leading: L
	private let trailing: T
	private let footer: F

	public init(_ title: String, icon: Image? = nil, @ViewBuilder content: () -> C, @ViewBuilder leading: () -> L = { EmptyView() }, @ViewBuilder trailing: () -> T = { EmptyView() }, @ViewBuilder footer: () -> F = { EmptyView() }) {
		self.title = title
		self.icon = icon
		self.content = content()
		self.leading = leading()
		self.trailing = trailing()
		self.footer = footer()
	}

	public var body: some View {
		ZStack {
			content
			VStack {
				ZStack {
					CaptionLabel(title, icon: icon)
					HStack {
						leading
						Spacer()
						trailing
					}
					.padding()
				}
				.background(
					LinearGradient(
						colors: [
							Color(uiColor: .systemBackground),
							.clear,
						],
						startPoint: .top,
						endPoint: .bottom
					)
				)
				Spacer()
				footer
					.frame(maxWidth: .infinity)
					.padding()
					.background(
						LinearGradient(
							colors: [
								Color(uiColor: .systemBackground),
								.clear,
							],
							startPoint: .bottom,
							endPoint: .top
						)
					)
			}
		}
	}
}
