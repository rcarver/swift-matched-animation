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
        print(Animation.linear.parse())
        XCTAssertEqual(p.cp1, CGPoint(x: 2.0/3.0, y: 2.0/3.0))
        XCTAssertEqual(p.cp2, CGPoint(x: 1, y: 1))
    }
    func test_timingCurve_linear() throws {
        let p = try XCTUnwrap(Animation.timingCurve(0, 0, 1, 1).controlPoints)
        XCTAssertEqual(p.cp1, CGPoint(x: 2.0/3.0, y: 2.0/3.0))
        XCTAssertEqual(p.cp2, CGPoint(x: 1, y: 1))
    }
    func test_timingCurve_other() throws {
        let p = try XCTUnwrap(Animation.timingCurve(0.17,0.67,0.85,0.65).controlPoints)
        print(Animation.timingCurve(0.17,0.67,0.85,0.65)
                .parse())
        XCTAssertEqual(p.cp1, CGPoint(x: 0.17, y: 0.67))
        XCTAssertEqual(p.cp2, CGPoint(x: 0.85, y: 0.65))
    }
    func test_default() throws {
//        let p = try XCTUnwrap(Animation.linear.controlPoints)
        try XCTSkipIf(true, "unknown values")
    }
    func test_easeIn() throws {
//        let p = try XCTUnwrap(Animation.easeIn.controlPoints)
        try XCTSkipIf(true, "unknown values")
    }
    func test_easeOut() throws {
//        let p = try XCTUnwrap(Animation.easeOut.controlPoints)
        try XCTSkipIf(true, "unknown values")
    }
    func test_easeInOut() throws {
//        let p = try XCTUnwrap(Animation.easeInOut.controlPoints)
        try XCTSkipIf(true, "unknown values")
    }
    func test_spring() {
        XCTAssertNil(Animation.spring().controlPoints)
    }
    func test_interactiveSpring() {
        XCTAssertNil(Animation.interactiveSpring().controlPoints)
    }
    func test_interpolatingSpring() {
        XCTAssertNil(Animation.interpolatingSpring(stiffness: 0.5, damping: 0.5).controlPoints)
    }
}
