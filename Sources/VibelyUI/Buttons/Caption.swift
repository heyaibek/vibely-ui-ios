import SwiftUI

public struct CaptionLabel: View {
	static let size: CGFloat = 32

	private let title: String
	private let icon: Image?
	private let titleWidth: CGFloat?
	private let loading: Bool

	public init(_ title: String, icon: Image? = nil, titleWidth: CGFloat? = .infinity, loading: Bool = false) {
		self.title = title
		self.icon = icon
		self.titleWidth = titleWidth
		self.loading = loading
	}

	public var body: some View {
		HStack {
			if loading {
				ProgressView()
					.progressViewStyle(.circular)
					.frame(width: Self.size / 2, height: Self.size / 2)
			} else if let icon {
				icon
					.symbolRenderingMode(.hierarchical)
					.imageScale(.small)
			}
			Text(title)
				.font(.caption2)
				.fontWeight(.semibold)
				.frame(width: titleWidth)
		}
		.padding(.horizontal, Self.size / 2)
		.frame(height: Self.size)
		.background(.ultraThinMaterial)
		.clipShape(.rect(cornerRadius: Self.size / 2))
	}
}

public struct CaptionButton: View {
	private let title: String
	private let icon: Image?
	private let titleWidth: CGFloat?
	private let loading: Bool
	private let role: ButtonRole?
	private let action: () -> Void

	public init(_ title: String, icon: Image? = nil, titleWidth: CGFloat? = .infinity, loading: Bool = false, role: ButtonRole? = nil, action: @escaping () -> Void) {
		self.title = title
		self.icon = icon
		self.titleWidth = titleWidth
		self.loading = loading
		self.role = role
		self.action = action
	}

	public var body: some View {
		Button(role: role) {
			action()
		} label: {
			CaptionLabel(title, icon: icon, titleWidth: titleWidth, loading: loading)
		}
		.tint(.primary)
		.disabled(loading)
	}
}

public struct CaptionMenu<C: View>: View {
	private let title: String
	private let icon: Image?
	private let titleWidth: CGFloat?
	private let loading: Bool
	private let content: C

	public init(_ title: String, icon: Image? = nil, titleWidth: CGFloat? = .infinity, loading: Bool = false, @ViewBuilder content: @escaping () -> C) {
		self.title = title
		self.icon = icon
		self.titleWidth = titleWidth
		self.loading = loading
		self.content = content()
	}

	public var body: some View {
		Menu {
			content
		} label: {
			CaptionLabel(title, icon: icon, titleWidth: titleWidth, loading: loading)
		}
		.tint(.primary)
		.disabled(loading)
	}
}
