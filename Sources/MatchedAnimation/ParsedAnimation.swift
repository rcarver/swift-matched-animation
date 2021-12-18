import SwiftUI

/// The result of parsing an Animation.
struct ParsedAnimation {
    var type: AnimationType?
    var baseDuration: Double?
    var speedMultipler: Double?
}

extension ParsedAnimation {
    var duration: Double? {
        guard let d = baseDuration else { return nil }
        guard let s = speedMultipler else { return d }
        return d * s
    }
    var controlPoints: ControlPoints? {
        switch type {
        case .bezier(let points):
            return points.controlPoints
        case .none:
            return nil
        }
    }
}

enum AnimationType {
    case bezier(BezierPoints)
}

/// Quadradic bezier; how Animation represents itself internally.
struct BezierPoints {
    let ax: CGFloat
    let ay: CGFloat
    let bx: CGFloat
    let by: CGFloat
    let cx: CGFloat
    let cy: CGFloat
}

/// Cubic bezier: how we convert to CoreGraphics, UIKit, and AppKit animations.
struct ControlPoints: Equatable {
    var cp1: CGPoint
    var cp2: CGPoint
}

extension BezierPoints {
    var controlPoints: ControlPoints {
        let cp1 = CGPoint(
            x: ((2 * cx) + ax) / 3,
            y: ((2 * cy) + ay) / 3
        )
        let cp2 = CGPoint(
            x: ((2 * cx) + bx) / 3,
            y: ((2 * cy) + by) / 3
        )
        return ControlPoints(cp1: cp1, cp2: cp2)
    }
}

// MARK: - Parsers

func parseAnimation(_ output: inout ParsedAnimation, mirror: Mirror) {
    let labels = mirror.children.map(\.label)
    switch labels {
    case ["duration", "curve"]:
        parseBezierAnimation(&output, mirror: mirror)
    case ["animation", "speed"]:
        parseSpeedAnimation(&output, mirror: mirror)
    default:
        break
    }
}

func parseBezierAnimation(_ output: inout ParsedAnimation, mirror: Mirror) {
    for c in mirror.children {
        switch c.label {
        case "duration":
            output.baseDuration = c.value as? Double
        case "curve":
            parseBezierTimingCurve(&output, mirror: Mirror(reflecting: c.value))
        default:
            break
        }
    }
}

func parseSpeedAnimation(_ output: inout ParsedAnimation, mirror: Mirror) {
    for c in mirror.children {
        switch c.label {
        case "speed":
            output.speedMultipler = c.value as? Double
        case "animation":
            parseAnimation(&output, mirror: Mirror(reflecting: c.value))
        default:
            break
        }
    }
}

func parseBezierTimingCurve(_ output: inout ParsedAnimation, mirror: Mirror) {
    var ax, ay, bx, by, cx, cy: Double?
    for c in mirror.children {
        switch c.label {
        case "ax": ax = c.value as? Double
        case "ay": ay = c.value as? Double
        case "bx": bx = c.value as? Double
        case "by": by = c.value as? Double
        case "cx": cx = c.value as? Double
        case "cy": cy = c.value as? Double
        default:
            break
        }
    }
    if let ax = ax, let ay = ay, let bx = bx, let by = by, let cx = cx, let cy = cy {
        output.type = .bezier(BezierPoints(ax: ax, ay: ay, bx: bx, by: by, cx: cx, cy: cy))
    }
}

func xcontrolPoints() -> ControlPoints? {

    /// The SwiftUI Animation to match
    let animation = Animation.easeInOut(duration: 1)
    print("input", animation)
    //BezierAnimation(duration: 1.0, curve: SwiftUI.(unknown context at $7fff5d38c400).BezierTimingCurve(ax: -2.0, bx:   3.0,  cx: 0.0,  ay: -2.0, by: 3.0, cy: 0.0))
    //BezierAnimation(duration: 1.0, curve: SwiftUI.(unknown context at $7fff5d38c400).BezierTimingCurve(ax:  0.52, bx: -0.78, cx: 1.26, ay: -2.0, by: 3.0, cy: 0.0))

    /// Copy the quadratic points
    let startA = CGPoint(x: -0.52, y: -3.0)
    let endA = CGPoint(x: -0.78, y: 3.0)
    let controlA = CGPoint(x: 1.26, y: 0.0)

    /// Copy the quadratic points
    let n: CGFloat = 1
    let start = CGPoint(x: startA.x/n, y: startA.y/n)
    let end = CGPoint(x: endA.x/n, y: endA.y/n)
    let control = CGPoint(x: controlA.x/n, y: controlA.y/n)

    let cp1 = CGPoint(
        x: ((2 * control.x) + start.x) / 3,
        y: ((2 * control.y) + start.y) / 3
    )
    let cp2 = CGPoint(
        x: ((2 * control.x) + end.x) / 3,
        y: ((2 * control.y) + end.y) / 3
    )

    // Constructing an animation from control points matches SwiftUI and UIKit
    let curve = Animation.timingCurve(cp1.x, cp1.y, cp2.x, cp2.y, duration: 1)
    print("curve", curve)

    print("cp1", cp1)
    print("cp2", cp2)

    return ControlPoints(cp1: cp1, cp2: cp1)
}
