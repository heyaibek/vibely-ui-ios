import SwiftUI

private struct SizeKey: PreferenceKey {
	static var defaultValue: CGFloat = .zero

	static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
		value = nextValue()
	}
}

// MARK: - RangeSlider

// https://www.hackingwithswift.com/books/ios-swiftui/how-to-use-gestures-in-swiftui
// https://sarunw.com/posts/move-view-around-with-drag-gesture-in-swiftui/
public struct RangeSlider<T: BinaryFloatingPoint>: View {
	@Binding private var minValue: T
	@Binding private var maxValue: T
	private var range: ClosedRange<T>
	private var distance: T
	private var dragHandler: ((Bool) -> Void)? = nil

	public init(min: Binding<T>, max: Binding<T>, range: ClosedRange<T>, distance: T = 0, dragHandler: ((Bool) -> Void)? = nil) {
		_minValue = min
		_maxValue = max
		self.range = range
		self.distance = distance
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

	@State private var width: CGFloat = 0
	@State private var distanceWidth: CGFloat = 0
	@State private var minLocation: CGPoint = .zero
	@State private var maxLocation: CGPoint = .zero
	@GestureState private var minStartLocation: CGPoint? = nil
	@GestureState private var maxStartLocation: CGPoint? = nil

	private var minDrag: some Gesture {
		DragGesture()
			.onChanged { value in
				let duration = CGFloat(range.upperBound - range.lowerBound)
				if duration <= 0 {
					return
				}

				var newLocation = minStartLocation ?? minLocation
				newLocation.x += value.translation.width

				if newLocation.x <= 0 {
					newLocation.x = 0
				}

				if newLocation.x >= maxLocation.x - distanceWidth {
					newLocation.x = maxLocation.x - distanceWidth
				}

				minLocation = newLocation
				minValue = range.lowerBound + T((newLocation.x * duration) / (width - thumbSize * 2))
			}
			.updating($minStartLocation) { _, location, _ in
				location = location ?? minLocation
			}
			.onEnded { _ in
				isDragging = false
			}
	}

	private var maxDrag: some Gesture {
		DragGesture()
			.onChanged { value in
				let duration = CGFloat(range.upperBound - range.lowerBound)
				if duration <= 0 {
					return
				}

				var newLocation = maxStartLocation ?? maxLocation
				newLocation.x += value.translation.width

				if newLocation.x <= minLocation.x + distanceWidth {
					newLocation.x = minLocation.x + distanceWidth
				}

				if newLocation.x >= width - thumbSize * 2 {
					newLocation.x = width - thumbSize * 2
				}

				maxLocation = newLocation
				maxValue = range.lowerBound + T((newLocation.x * duration) / (width - thumbSize * 2))
			}
			.updating($maxStartLocation) { _, location, _ in
				location = location ?? maxLocation
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
				Rectangle()
					.foregroundStyle(isEnabled ? lineColor : SliderConstants.defaultDisabledColor)
					.frame(width: maxLocation.x - minLocation.x, height: lineWidth)
					.offset(x: minLocation.x + thumbSize)
				HStack(spacing: 0) {
					Circle()
						.shadow(color: .black.opacity(0.24), radius: 4, x: 0, y: 2)
						.frame(width: thumbSize, height: thumbSize)
						.offset(x: minLocation.x)
						.gesture(longPress.sequenced(before: minDrag))
					Circle()
						.shadow(color: .black.opacity(0.24), radius: 4, x: 0, y: 2)
						.frame(width: thumbSize, height: thumbSize)
						.offset(x: maxLocation.x)
						.gesture(longPress.sequenced(before: maxDrag))
				}
				.foregroundStyle(isEnabled ? thumbColor : SliderConstants.defaultDisabledColor)
				.frame(width: width, alignment: .leading)
			}
			.preference(key: SizeKey.self, value: geo.size.width)
			.onAppear {
				updateLocations()
			}
			.onChange(of: width, perform: { _ in
				updateLocations()
			})
			.onChange(of: minValue, perform: { _ in
				updateLocations()
			})
			.onChange(of: maxValue, perform: { _ in
				updateLocations()
			})
		}
		.frame(height: thumbSize)
		.onPreferenceChange(SizeKey.self) {
			width = $0
			distanceWidth = (CGFloat(distance) * (width - thumbSize * 2)) / CGFloat(range.upperBound - range.lowerBound)
		}
	}

	private func updateLocations() {
		if isDragging { return }

		let minX = (minValue * T(width - thumbSize * 2)) / (range.upperBound - range.lowerBound)
		let maxX = (maxValue * T(width - thumbSize * 2)) / (range.upperBound - range.lowerBound)

		minLocation.x = minX.isNormal ? CGFloat(minX) : 0
		maxLocation.x = maxX.isNormal ? CGFloat(maxX) : 0
	}
}

public extension RangeSlider {
	func thumbColor(_ value: Color) -> RangeSlider {
		var view = self
		view.thumbColor = value
		return view
	}

	func thumbSize(_ value: CGFloat) -> RangeSlider {
		var view = self
		view.thumbSize = value
		return view
	}

	func lineColor(_ value: Color) -> RangeSlider {
		var view = self
		view.lineColor = value
		return view
	}

	func lineWidth(_ value: CGFloat) -> RangeSlider {
		var view = self
		view.lineWidth = value
		return view
	}
}
