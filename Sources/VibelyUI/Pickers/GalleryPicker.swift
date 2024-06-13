import PhotosUI
import SwiftUI

public struct GalleryPicker: UIViewControllerRepresentable {
	private var filter: PHPickerFilter
	@Binding private var url: URL?
	@Binding private var loading: Bool
	@Binding private var error: ErrorWrapper?

	public init(filter: PHPickerFilter, url: Binding<URL?>, loading: Binding<Bool>, error: Binding<ErrorWrapper?>) {
		self.filter = filter
		_url = url
		_loading = loading
		_error = error
	}

	public func makeUIViewController(context: Context) -> PHPickerViewController {
		var configuration = PHPickerConfiguration()
		configuration.selectionLimit = 1
		configuration.filter = filter
		configuration.preferredAssetRepresentationMode = .automatic

		let controller = PHPickerViewController(configuration: configuration)
		controller.delegate = context.coordinator
		return controller
	}

	public func updateUIViewController(_: PHPickerViewController, context _: Context) {}

	public func makeCoordinator() -> Coordinator {
		Coordinator(parent: self)
	}

	public class Coordinator: PHPickerViewControllerDelegate {
		private var parent: GalleryPicker

		init(parent: GalleryPicker) {
			self.parent = parent
		}

		public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
			picker.dismiss(animated: true)

			guard let result = results.first else {
				return
			}

			let itemProvider = result.itemProvider
			guard let typeIdentifier = itemProvider.registeredTypeIdentifiers.first else {
				return
			}

			parent.loading = true

			getFile(from: itemProvider, typeIdentifier: typeIdentifier)
		}

		private func getFile(from itemProvider: NSItemProvider, typeIdentifier: String) {
			itemProvider.loadFileRepresentation(forTypeIdentifier: typeIdentifier) { url, error in
				if error != nil {
					return
				}

				guard let sourceURL = url else {
					return
				}

				guard let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
					return
				}

				let targetURL = cacheDirectory.appendingPathComponent(sourceURL.lastPathComponent)

				do {
					if FileManager.default.fileExists(atPath: targetURL.path) {
						try FileManager.default.removeItem(at: targetURL)
					}

					try FileManager.default.copyItem(at: sourceURL, to: targetURL)

					DispatchQueue.main.async {
						self.parent.loading = false
						self.parent.url = targetURL
					}
				} catch {
					DispatchQueue.main.async {
						self.parent.error = ErrorWrapper(error: error)
					}
				}
			}
		}
	}
}
