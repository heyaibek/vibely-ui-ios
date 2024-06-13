import SwiftUI

public struct TransparentBackground: UIViewRepresentable {
	public init() {}

	public func makeUIView(context _: Context) -> UIView {
		InternalView()
	}

	public func updateUIView(_: UIView, context _: Context) {}

	private class InternalView: UIView {
		override func didMoveToWindow() {
			super.didMoveToWindow()
			superview?.superview?.backgroundColor = .clear
		}
	}
}
