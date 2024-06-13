import SwiftUI

public struct CircleLabel: View {
	public enum Variant {
		case `default`
		case small

		var size: CGFloat {
			switch self {
			case .default: return 40
			case .small: return 32
			}
		}

		var imageScale: Image.Scale {
			switch self {
			case .default: return .medium
			case .small: return .small
			}
		}
	}

	private var icon: Image
	private var variant: Variant
	private var loading: Bool

	public init(_ icon: Image, variant: Variant = .default, loading: Bool = false) {
		self.icon = icon
		self.variant = variant
		self.loading = loading
	}

	public var body: some View {
		ZStack {
			if loading {
				ProgressView()
					.progressViewStyle(.circular)
			} else {
				icon
					.symbolRenderingMode(.hierarchical)
					.imageScale(variant.imageScale)
			}
		}
		.frame(width: variant.size, height: variant.size)
		.background(.ultraThinMaterial)
		.clipShape(.rect(cornerRadius: variant.size / 2))
	}
}

public struct CircleButton: View {
	private var icon: Image
	private var variant: CircleLabel.Variant
	private var loading: Bool
	private var role: ButtonRole?
	private var action: () -> Void

	public init(_ icon: Image, variant: CircleLabel.Variant = .default, loading: Bool = false, role: ButtonRole? = nil, action: @escaping () -> Void) {
		self.icon = icon
		self.variant = variant
		self.loading = loading
		self.role = role
		self.action = action
	}

	public var body: some View {
		Button(role: role) {
			action()
		} label: {
			CircleLabel(icon, variant: variant, loading: loading)
		}
		.tint(.primary)
		.disabled(loading)
	}
}

public struct CircleMenu<C: View>: View {
	private var icon: Image
	private var variant: CircleLabel.Variant
	private var loading: Bool
	private var content: C

	public init(_ icon: Image, variant: CircleLabel.Variant = .default, loading: Bool = false, @ViewBuilder content: () -> C) {
		self.icon = icon
		self.variant = variant
		self.loading = loading
		self.content = content()
	}

	public var body: some View {
		Menu {
			content
		} label: {
			CircleLabel(icon, variant: variant, loading: loading)
		}
		.tint(.primary)
		.disabled(loading)
	}
}
