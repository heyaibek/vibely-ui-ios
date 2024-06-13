import SwiftUI

public struct ActionLabel: View {
	public enum Variant {
		case primary
		case primaryLarge
		case secondary
		case secondaryLarge

		var size: CGFloat {
			switch self {
			case .primary, .secondary: 40
			case .primaryLarge, .secondaryLarge: 50
			}
		}

		var style: AnyShapeStyle {
			switch self {
			case .primary, .primaryLarge: AnyShapeStyle(TintShapeStyle.tint)
			case .secondary, .secondaryLarge: AnyShapeStyle(Material.ultraThinMaterial)
			}
		}

		var font: Font {
			switch self {
			case .primary, .secondary: Font.callout
			case .primaryLarge, .secondaryLarge: Font.title3
			}
		}

		var imageScale: Image.Scale {
			switch self {
			case .primary, .secondary: .medium
			case .primaryLarge, .secondaryLarge: .large
			}
		}

		var foreground: Color {
			switch self {
			case .primary, .primaryLarge: .white
			case .secondary, .secondaryLarge: .primary
			}
		}
	}

	private let title: String
	private let icon: Image?
	private let variant: Variant
	private let loading: Bool
	private let role: ButtonRole?

	public init(_ title: String, icon: Image? = nil, variant: Variant = .primary, loading: Bool = false, role: ButtonRole? = nil) {
		self.title = title
		self.icon = icon
		self.variant = variant
		self.loading = loading
		self.role = role
	}

	public var body: some View {
		HStack {
			if loading {
				ProgressView()
					.progressViewStyle(.circular)
					.padding(.trailing, 10)
			} else if let icon {
				icon
					.symbolRenderingMode(.hierarchical)
					.imageScale(variant.imageScale)
			}
			Text(title)
				.font(variant.font)
				.fontWeight(.semibold)
		}
		.foregroundStyle(role == .destructive ? .white : variant.foreground)
		.frame(height: variant.size)
		.padding(.horizontal, variant.size / 2)
		.background(role == .destructive ? AnyShapeStyle(.red) : variant.style)
		.clipShape(.rect(cornerRadius: variant.size / 2))
	}
}

extension ButtonStyle where Self == ActionButtonStyle {
	static var action: ActionButtonStyle {
		ActionButtonStyle()
	}
}

struct ActionButtonStyle: ButtonStyle {
	func makeBody(configuration: Configuration) -> some View {
		configuration
			.label
			.scaleEffect(configuration.isPressed ? 0.9 : 1.0)
			.animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
	}
}

public struct ActionButton: View {
	private let title: String
	private let icon: Image?
	private let variant: ActionLabel.Variant
	private let loading: Bool
	private let role: ButtonRole?
	private let action: () -> Void

	public init(_ title: String, icon: Image? = nil, variant: ActionLabel.Variant = .primary, loading: Bool = false, role: ButtonRole? = nil, action: @escaping () -> Void) {
		self.title = title
		self.icon = icon
		self.variant = variant
		self.loading = loading
		self.role = role
		self.action = action
	}

	public var body: some View {
		Button {
			action()
		} label: {
			ActionLabel(title, icon: icon, variant: variant, loading: loading, role: role)
		}
		.buttonStyle(.action)
		.disabled(loading)
	}
}

public struct ActionMenu<C: View>: View {
	private let title: String
	private let icon: Image?
	private let variant: ActionLabel.Variant
	private let loading: Bool
	private let role: ButtonRole?
	private let content: C

	public init(_ title: String, icon: Image? = nil, variant: ActionLabel.Variant = .primary, loading: Bool = false, role: ButtonRole? = nil, @ViewBuilder content: () -> C) {
		self.title = title
		self.icon = icon
		self.variant = variant
		self.loading = loading
		self.role = role
		self.content = content()
	}

	public var body: some View {
		Menu {
			content
		} label: {
			ActionLabel(title, icon: icon, variant: variant, loading: loading, role: role)
		}
		.buttonStyle(.action)
		.disabled(loading)
	}
}
