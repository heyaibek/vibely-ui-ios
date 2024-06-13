import SwiftUI

private struct SizeKey: PreferenceKey {
	static var defaultValue: CGFloat = .zero

	static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
		value = nextValue()
	}
}

public struct CenterSlider<T: BinaryFloatingPoint>: View {
	@Binding private var value: T
	private let range: ClosedRange<T>

	public init(value: Binding<T>, range: ClosedRange<T>) {
		_value = value
		self.range = range
	}

	private var thumbColor = SliderConstants.defaultThumbColor
	private var thumbSize = SliderConstants.defaultThumbSize
	private var lineColor = SliderConstants.defaultLineColor
	private var lineWidth = SliderConstants.defaultLineWidth

	private var duration: T {
		range.upperBound - range.lowerBound
	}

	private var offset: T {
		abs(0 - range.lowerBound)
	}

	private var valuePosition: T {
		(value + offset) / duration
	}

	private var valueXPosition: CGFloat {
		let x = (width - thumbSize) * CGFloat(valuePosition)
		return x.isNormal ? CGFloat(x) : 0
	}

	private var centerPosition: T {
		(0 + offset) / duration
	}

	private var centerXPosition: CGFloat {
		let x = (width - thumbSize) * CGFloat(centerPosition)
		return x.isNormal ? CGFloat(x) : 0
	}

	private var intervalWidth: CGFloat {
		abs(centerXPosition - location.x)
	}

	@Environment(\.isEnabled) private var isEnabled: Bool
	@State private var isDragging = false {
		didSet {
//			dragHandler?(isDragging)
		}
	}

	@State private var width: CGFloat = .zero
	@State private var location: CGPoint = .zero
	@GestureState private var startLocation: CGPoint? = nil

	private var drag: some Gesture {
		DragGesture()
			.onChanged { value in
				if duration <= 0 {
					return
				}

				var newLocation = startLocation ?? location
				newLocation.x += value.translation.width

				if newLocation.x <= 0 {
					newLocation.x = 0
				}

				if newLocation.x >= width - thumbSize {
					newLocation.x = width - thumbSize
				}

				location = newLocation

				let position = location.x / (width - thumbSize)
				let relativeValue = duration * T(position)

				self.value = relativeValue - offset
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
		let locX = location.x
		let lineOffset = locX < centerXPosition ? locX : centerXPosition

		GeometryReader { geo in
			ZStack(alignment: .leading) {
				RoundedRectangle(cornerRadius: lineWidth / 2)
					.foregroundStyle(Color(uiColor: .tertiarySystemBackground))
					.frame(height: lineWidth)
				RoundedRectangle(cornerRadius: lineWidth / 2)
					.foregroundStyle(isEnabled ? lineColor : SliderConstants.defaultDisabledColor)
					.frame(width: intervalWidth, height: lineWidth)
					.offset(x: lineOffset + thumbSize / 2)
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
		if isDragging {
			return
		}
		location.x = valueXPosition
	}
}

public extension CenterSlider {
	func thumbColor(_ value: Color) -> CenterSlider {
		var view = self
		view.thumbColor = value
		return view
	}

	func thumbSize(_ value: CGFloat) -> CenterSlider {
		var view = self
		view.thumbSize = value
		return view
	}

	func lineColor(_ value: Color) -> CenterSlider {
		var view = self
		view.lineColor = value
		return view
	}

	func lineWidth(_ value: CGFloat) -> CenterSlider {
		var view = self
		view.lineWidth = value
		return view
	}
}
