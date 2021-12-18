import SwiftUI
import XCTest
@testable import MatchedAnimation

final class AnimationTests: XCTestCase {

    func test_duration() {
        XCTAssertEqual(Animation.default.duration, 0.35)
        XCTAssertEqual(Animation.linear(duration: 0.5).duration, 0.5)
        XCTAssertEqual(Animation.linear(duration: 1.0).duration, 1.0)
        XCTAssertEqual(Animation.easeInOut(duration: 1.0).duration, 1.0)
    }
}
