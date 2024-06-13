import SwiftUI

public struct TextPicker: View {
	enum FocusedField {
		case valueField
	}

	private var title: String
	private var value: String
	private var icon: Image
	private var onUse: (String) -> Void

	public init(_ title: String, value: String, icon: Image, onUse: @escaping (String) -> Void) {
		self.title = title
		self.value = value
		self.icon = icon
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
			VStack(spacing: 0) {
				HStack {
					icon
					Text(title)
				}
				.font(.headline)
				.lineLimit(1)
				.padding()

				TextField(value, text: $stringValue)
					.font(.title)
					.keyboardType(.alphabet)
					.multilineTextAlignment(.center)
					.padding()
					.frame(maxHeight: .infinity)
					.focused($focusedField, equals: .valueField)
					.onSubmit {
						cancelling = true
						dismiss()

						onUse(stringValue)
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

						onUse(stringValue)
					}
					.disabled(!canUse)
				}
				.padding()
			}
			.background(.ultraThinMaterial)
		}
		.onAppear {
			stringValue = value
			focusedField = .valueField
		}
		.onChange(of: stringValue) { stringValue in
			canUse = !stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
				.isEmpty
		}
	}
}
