import SwiftUI

public struct ToolLabel: View {
	public static let height: CGFloat = 56
	public static let minWidth: CGFloat = 64
	public static let iconSize: CGFloat = 24

	private var title: String
	private var icon: Image
	private var loading: Bool
	private var focused: Bool

	public init(_ title: String, icon: Image, loading: Bool = false, focused: Bool = false) {
		self.title = title
		self.icon = icon
		self.loading = loading
		self.focused = focused
	}

	public var body: some View {
		VStack(spacing: 0) {
			if loading {
				ProgressView()
					.frame(width: Self.iconSize, height: Self.iconSize)
					.progressViewStyle(.circular)
			} else {
				icon
					.frame(width: Self.iconSize, height: Self.iconSize)
					.symbolRenderingMode(.hierarchical)
			}
			Text(title)
				.font(.caption2)
		}
		.padding(.horizontal)
		.frame(height: Self.height)
		.frame(minWidth: Self.minWidth)
		.background(.ultraThinMaterial)
		.background(focused ? .green : .clear)
		.clipShape(.rect(cornerRadius: 8))
	}
}

public struct ToolButton: View {
	private var title: String
	private var icon: Image
	private var loading: Bool
	private var focused: Bool
	private var role: ButtonRole?
	private var action: () -> Void

	public init(_ title: String, icon: Image, loading: Bool = false, focused: Bool = false, role: ButtonRole? = nil, action: @escaping () -> Void) {
		self.title = title
		self.icon = icon
		self.loading = loading
		self.focused = focused
		self.role = role
		self.action = action
	}

	public var body: some View {
		Button(role: role) {
			action()
		} label: {
			ToolLabel(title, icon: icon, loading: loading, focused: focused)
		}
		.tint(.primary)
		.disabled(loading)
	}
}

public struct ToolMenu<C>: View where C: View {
	private var title: String
	private var icon: Image
	private var loading: Bool
	private var focused: Bool
	private var content: C

	public init(_ title: String, icon: Image, loading: Bool = false, focused: Bool = false, @ViewBuilder content: () -> C) {
		self.title = title
		self.icon = icon
		self.loading = loading
		self.focused = focused
		self.content = content()
	}

	public var body: some View {
		Menu {
			content
		} label: {
			ToolLabel(title, icon: icon, loading: loading, focused: focused)
		}
		.tint(.primary)
		.disabled(loading)
	}
}
