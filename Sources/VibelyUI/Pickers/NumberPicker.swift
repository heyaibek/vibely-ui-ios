import SwiftUI

public struct NumberPicker<T: BinaryFloatingPoint>: View {
	enum FocusedField {
		case valueField
	}

	private var title: String
	private var value: T
	private var icon: Image
	private var range: ClosedRange<T>
	private var format: String
	private var onUse: (T) -> Void

	public init(_ title: String, value: T, icon: Image, range: ClosedRange<T>, format: String = "%.0f", onUse: @escaping (T) -> Void) {
		self.title = title
		self.value = value
		self.icon = icon
		self.range = range
		self.format = format
		self.onUse = onUse
	}

	@Environment(\.dismiss) private var dismiss
	@State private var cancelling = false
	@State private var focused = false
	@State private var canUse = false
	@State private var stringValue = ""
	@FocusState private var focusedField: FocusedField?

	public var body: some View {
		VStack {
			VStack(spacing: 5) {
				HStack {
					icon
					Text(title)
				}
				.font(.headline)
				HStack {
					Text(String(format: format, floorf(Float(range.lowerBound))))
					Text("-")
					Text(String(format: format, floorf(Float(range.upperBound))))
				}
				.font(.footnote)
				.foregroundStyle(.secondary)
			}
			.lineLimit(1)
			.padding()

			TextField(String(format: "%.0f", Float(value)), text: $stringValue)
				.font(.title)
				.keyboardType(.numberPad)
				.multilineTextAlignment(.center)
				.padding()
				.frame(maxHeight: .infinity)
				.focused($focusedField, equals: .valueField)
				.onSubmit {
					cancelling = true
					dismiss()

					let floatValue = Float(stringValue) ?? Float(range.lowerBound)
					onUse(T(floatValue))
				}

			HStack {
				CircleButton(.systemChevronDown) {
					cancelling = true
					dismiss()
				}
				Spacer()
				CircleButton(.systemCheckmark) {
					cancelling = true
					dismiss()

					let floatValue = Float(stringValue) ?? Float(range.lowerBound)
					onUse(T(floatValue))
				}
				.disabled(!canUse)
			}
			.padding()
		}
		.background(.ultraThinMaterial)
		.onAppear {
			stringValue = String(format: "%.0f", Float(value))
			focusedField = .valueField
		}
		.onChange(of: stringValue) { stringValue in
			let floatValue = Float(stringValue) ?? Float(range.lowerBound)
			let minValue = Float(range.lowerBound)
			let maxValue = Float(range.upperBound)

			canUse = floatValue >= minValue && floatValue <= maxValue
		}
	}
}
