import Foundation

enum WordGridSubmissionResult: Equatable {
    case accepted(word: String, points: Int)
    case tooShort
    case invalidWord
    case alreadyFound
}
