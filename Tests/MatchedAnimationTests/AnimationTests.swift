import SwiftUI
import XCTest
@testable import MatchedAnimation

final class AnimationDurationTests: XCTestCase {
    func test_duration() {
        XCTAssertEqual(Animation.default.duration, 0.35)
        XCTAssertEqual(Animation.linear(duration: 0.5).duration, 0.5)
        XCTAssertEqual(Animation.linear(duration: 1.0).duration, 1.0)
        XCTAssertEqual(Animation.easeInOut(duration: 1.0).duration, 1.0)
    }
    func test_duration_speed() {
        XCTAssertEqual(Animation.easeInOut(duration: 1.0).speed(2).duration, 2.0)
    }
}

final class AnimationControlPointTests: XCTestCase {
    func test_linear() throws {
        let p = try XCTUnwrap(Animation.linear.controlPoints)
        XCTAssertEqual(p.cp1, CGPoint(x: 0, y: 0))
        XCTAssertEqual(p.cp2, CGPoint(x: 1, y: 1))
    }
    func test_default() throws {
        let p = try XCTUnwrap(Animation.linear.controlPoints)
        try XCTSkipIf(true, "unknown values")
    }
    func test_easeIn() throws {
        let p = try XCTUnwrap(Animation.easeIn.controlPoints)
        try XCTSkipIf(true, "unknown values")
    }
    func test_easeOut() throws {
        let p = try XCTUnwrap(Animation.easeOut.controlPoints)
        try XCTSkipIf(true, "unknown values")
    }
    func test_easeInOut() throws {
        let p = try XCTUnwrap(Animation.easeInOut.controlPoints)
        try XCTSkipIf(true, "unknown values")
    }
    func test_spring() {
        XCTAssertNil(Animation.spring().uiPropertyAnimator)
    }
    func test_interactiveSpring() {
        XCTAssertNil(Animation.interactiveSpring().uiPropertyAnimator)
    }
    func test_interpolatingSpring() {
        XCTAssertNil(Animation.interpolatingSpring(stiffness: 0.5, damping: 0.5).uiPropertyAnimator)
    }
}
