import SwiftUI

struct Sliders: View {
	@State private var isDisabled = false
	@State private var isCustomized = false

	@State private var min = CGFloat(20)
	@State private var max = CGFloat(80)
	@State private var centerSlider = CGFloat(25)
	@State private var slider = CGFloat(50)
	@State private var range = CGFloat(0) ... CGFloat(100)

	var body: some View {
		PageLayoutView("Sliders", icon: .systemSliderHorizontal3) {
			ScrollView {
				VStack {
					VSection("Controls") {
						Toggle("Is Disabled?", isOn: $isDisabled)
						Toggle("Is Customized?", isOn: $isCustomized.animation())
					}
					VSection("Center Slider") {
						CenterSlider(value: $centerSlider, range: -50 ... 50)
							.thumbColor(isCustomized ? .yellow : SliderConstants.defaultThumbColor)
							.thumbSize(isCustomized ? 20 : SliderConstants.defaultThumbSize)
							.lineWidth(isCustomized ? 3 : SliderConstants.defaultLineWidth)
							.lineColor(isCustomized ? .purple : SliderConstants.defaultLineColor)
							.disabled(isDisabled)
						HStack {
							Text("-50")
							Spacer()
							Text(centerSlider.description)
							Spacer()
							Text("50")
						}
						.font(.caption)
						.foregroundStyle(.secondary)
					}
					VSection("Range Slider") {
						RangeSlider(min: $min, max: $max, range: range, distance: 5)
							.thumbColor(isCustomized ? .yellow : SliderConstants.defaultThumbColor)
							.thumbSize(isCustomized ? 20 : SliderConstants.defaultThumbSize)
							.lineWidth(isCustomized ? 3 : SliderConstants.defaultLineWidth)
							.lineColor(isCustomized ? .purple : SliderConstants.defaultLineColor)
							.disabled(isDisabled)
						HStack {
							Text(min.description)
							Spacer()
							Text(max.description)
						}
						.font(.caption)
						.foregroundStyle(.secondary)
					}
					VSection("Single Slider") {
						SingleSlider(value: $slider, range: range)
							.thumbColor(isCustomized ? .yellow : SliderConstants.defaultThumbColor)
							.thumbSize(isCustomized ? 20 : SliderConstants.defaultThumbSize)
							.lineWidth(isCustomized ? 3 : SliderConstants.defaultLineWidth)
							.lineColor(isCustomized ? .purple : SliderConstants.defaultLineColor)
							.disabled(isDisabled)
						HStack {
							Text(slider.description)
						}
						.font(.caption)
						.foregroundStyle(.secondary)
					}
				}
				.padding(.top, 56)
			}
		}
		.tabItem {
			Label("Sliders", systemImage: "slider.horizontal.3")
		}
	}
}
