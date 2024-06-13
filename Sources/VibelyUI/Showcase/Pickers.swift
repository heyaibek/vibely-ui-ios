import SwiftUI

struct Pickers: View {
	private var numberFormat = "%.0fpx"

	@State private var number = CGFloat(50)
	@State private var text = "Change Me"
	@State private var fontName = "Futura-Bold"
	@State private var imageURL: URL? = nil
	@State private var videoURL: URL? = nil
	@State private var audioURL: URL? = nil
	@State private var pickerError: ErrorWrapper? = nil

	@State private var imageLoading = false
	@State private var videoLoading = false
	@State private var audioLoading = false

	@State private var showTextPicker = false
	@State private var showNumberPicker = false
	@State private var showFontPicker = false
	@State private var showImagePicker = false
	@State private var showVideoPicker = false
	@State private var showAudioPicker = false

	var body: some View {
		PageLayoutView("Pickers", icon: .systemRectangleCenterInsetFilled) {
			ScrollView {
				VStack {
					HSection("Number Picker") {
						Button(String(format: numberFormat, number)) {
							showNumberPicker.toggle()
						}
						.buttonStyle(.bordered)
						.fullScreenCover(isPresented: $showNumberPicker) {
							NumberPicker("Text Picker", value: number, icon: .systemXSquare, range: 0 ... 100, format: numberFormat) { selection in
								number = selection
							}
							.background(TransparentBackground())
						}
						Spacer()
					}
					HSection("Text Picker") {
						Button(text) {
							showTextPicker.toggle()
						}
						.buttonStyle(.bordered)
						.fullScreenCover(isPresented: $showTextPicker) {
							TextPicker("Text Picker", value: text, icon: .systemTextformatAlt) { selection in
								text = selection
							}
							.background(TransparentBackground())
						}
						Spacer()
					}
					HSection("Font Picker") {
						Button(fontName) {
							showFontPicker.toggle()
						}
						.font(.custom(fontName, size: 14))
						.buttonStyle(.bordered)
						.sheet(isPresented: $showFontPicker) {
							FontPicker(selection: $fontName)
						}
						Spacer()
					}
					HSection("Image Picker") {
						ActionButton("Pick Image", icon: .systemPlus, variant: .secondary, loading: imageLoading) {
							showImagePicker.toggle()
						}
						.sheet(isPresented: $showImagePicker) {
							GalleryPicker(
								filter: .images,
								url: $imageURL,
								loading: $imageLoading,
								error: $pickerError
							)
						}
						Spacer()
						if let imageURL {
							Text(imageURL.description)
								.lineLimit(1)
						}
					}
					HSection("Video Picker") {
						ActionButton("Pick Video", icon: .systemPlus, variant: .secondary, loading: videoLoading) {
							showVideoPicker.toggle()
						}
						.sheet(isPresented: $showVideoPicker) {
							GalleryPicker(
								filter: .videos,
								url: $videoURL,
								loading: $videoLoading,
								error: $pickerError
							)
						}
						Spacer()
						if let videoURL {
							Text(videoURL.description)
								.lineLimit(1)
						}
					}
					HSection("Files Audio Picker") {
						ActionButton("Pick File", icon: .systemPlus, variant: .secondary, loading: audioLoading) {
							showAudioPicker.toggle()
						}
						.sheet(isPresented: $showAudioPicker) {
							FileAudioPicker(url: $audioURL, loading: $audioLoading, error: $pickerError)
						}
						Spacer()
						if let audioURL {
							Text(audioURL.description)
								.lineLimit(1)
						}
					}
				}
				.padding(.top, 56)
			}
		}
		.onChange(of: pickerError) { _ in
		}
		.tabItem {
			Label("Pickers", systemImage: "rectangle.center.inset.filled")
		}
	}
}
