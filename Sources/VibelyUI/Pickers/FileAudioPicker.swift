import SwiftUI
import UniformTypeIdentifiers

public struct FileAudioPicker: UIViewControllerRepresentable {
	@Binding private var url: URL?
	@Binding private var loading: Bool
	@Binding private var error: ErrorWrapper?

	public init(url: Binding<URL?>, loading: Binding<Bool>, error: Binding<ErrorWrapper?>) {
		_url = url
		_loading = loading
		_error = error
	}

	public func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
		let controller = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.audio], asCopy: true)
		controller.allowsMultipleSelection = false
		controller.delegate = context.coordinator
		return controller
	}

	public func updateUIViewController(_: UIDocumentPickerViewController, context _: Context) {}

	public func makeCoordinator() -> Coordinator {
		Coordinator(parent: self)
	}

	public class Coordinator: NSObject, UIDocumentPickerDelegate {
		private var parent: FileAudioPicker

		init(parent: FileAudioPicker) {
			self.parent = parent
		}

		public func documentPicker(_: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
			guard let url = urls.first else {
				return
			}

			parent.loading = true

			do {
				guard let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
					return
				}

				let fileDestination = cacheDirectory.appendingPathComponent(url.lastPathComponent)
				if FileManager.default.fileExists(atPath: fileDestination.path) {
					try FileManager.default.removeItem(atPath: fileDestination.path)
				}

				try FileManager.default.copyItem(at: url, to: fileDestination)

				DispatchQueue.main.async {
					self.parent.loading = false
					self.parent.url = fileDestination
				}
			} catch {
				DispatchQueue.main.async {
					self.parent.error = ErrorWrapper(error: error)
				}
			}
		}
	}
}
