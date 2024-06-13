import Foundation

public struct ErrorWrapper: Identifiable {
	public let id = UUID().uuidString
	public let error: Error

	public init(error: Error) {
		self.error = error
	}
}

extension ErrorWrapper: Equatable {
	public static func == (lhs: ErrorWrapper, rhs: ErrorWrapper) -> Bool {
		lhs.id == rhs.id
	}
}
