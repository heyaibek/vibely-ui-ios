import SwiftUI

private struct SizeKey: PreferenceKey {
	static var defaultValue: CGFloat = .zero

	static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
		value = nextValue()
	}
}

// https://sarunw.com/posts/move-view-around-with-drag-gesture-in-swiftui/
public struct SingleSlider<T: BinaryFloatingPoint>: View {
	@Binding private var value: T
	private var range: ClosedRange<T>
	private var dragHandler: ((Bool) -> Void)? = nil

	public init(value: Binding<T>, range: ClosedRange<T>, dragHandler: ((Bool) -> Void)? = nil) {
		_value = value
		self.range = range
		self.dragHandler = dragHandler
	}

	private var thumbColor = SliderConstants.defaultThumbColor
	private var thumbSize = SliderConstants.defaultThumbSize
	private var lineColor = SliderConstants.defaultLineColor
	private var lineWidth = SliderConstants.defaultLineWidth

	@Environment(\.isEnabled) private var isEnabled: Bool
	@State private var isDragging = false {
		didSet {
			dragHandler?(isDragging)
		}
	}

	@State private var width: CGFloat = .zero
	@State private var location: CGPoint = .zero
	@GestureState private var startLocation: CGPoint? = nil

	private var drag: some Gesture {
		DragGesture()
			.onChanged { value in
				var newLocation = startLocation ?? location
				newLocation.x += value.translation.width
				if newLocation.x <= 0 {
					newLocation.x = 0
				}
				if newLocation.x >= width - thumbSize {
					newLocation.x = width - thumbSize
				}

				let duration = CGFloat(range.upperBound - range.lowerBound)
				if duration <= 0 {
					return
				}

				location = newLocation
				self.value = range.lowerBound + T((newLocation.x * duration) / (width - thumbSize))
			}
			.updating($startLocation) { _, startLocation, _ in
				startLocation = startLocation ?? location
			}
			.onEnded { _ in
				isDragging = false
			}
	}

	private var longPress: some Gesture {
		LongPressGesture(minimumDuration: 0.0)
			.onEnded { _ in
				isDragging = true
			}
	}

	public var body: some View {
		GeometryReader { geo in
			ZStack(alignment: .leading) {
				RoundedRectangle(cornerRadius: lineWidth / 2)
					.foregroundStyle(Color(uiColor: .tertiarySystemBackground))
					.frame(height: lineWidth)
				RoundedRectangle(cornerRadius: lineWidth / 2)
					.foregroundStyle(isEnabled ? lineColor : SliderConstants.defaultDisabledColor)
					.frame(width: location.x + lineWidth, height: lineWidth)
				Circle()
					.foregroundStyle(isEnabled ? thumbColor : SliderConstants.defaultDisabledColor)
					.shadow(color: .black.opacity(0.24), radius: 4, x: 0, y: 2)
					.frame(width: thumbSize, height: thumbSize)
					.offset(x: location.x)
					.gesture(longPress.sequenced(before: drag))
			}
			.preference(key: SizeKey.self, value: geo.size.width)
			.onAppear {
				updateLocation()
			}
			.onChange(of: width) { _ in
				updateLocation()
			}
			.onChange(of: value) { _ in
				updateLocation()
			}
		}
		.frame(height: thumbSize)
		.onPreferenceChange(SizeKey.self) {
			width = $0
		}
	}

	private func updateLocation() {
		if isDragging { return }
		let x = (value * T(width - thumbSize)) / (range.upperBound - range.lowerBound)
		location.x = x.isNormal ? CGFloat(x) : 0
	}
}

public extension SingleSlider {
	func thumbColor(_ value: Color) -> SingleSlider {
		var view = self
		view.thumbColor = value
		return view
	}

	func thumbSize(_ value: CGFloat) -> SingleSlider {
		var view = self
		view.thumbSize = value
		return view
	}

	func lineColor(_ value: Color) -> SingleSlider {
		var view = self
		view.lineColor = value
		return view
	}

	func lineWidth(_ value: CGFloat) -> SingleSlider {
		var view = self
		view.lineWidth = value
		return view
	}
}
