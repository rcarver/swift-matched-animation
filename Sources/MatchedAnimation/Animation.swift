import SwiftUI

#if canImport(UIKit)
extension Animation {
    /// Create a UIPropertyAnimator that matches this Animation.
    public var uiPropertyAnimator: UIViewPropertyAnimator? {
        guard let controlPoints = self.controlPoints else { return nil }
        return UIViewPropertyAnimator(
            duration: self.duration ?? 0.35,
            controlPoint1: controlPoints.cp1,
            controlPoint2: controlPoints.cp2
        )
    }
}
#endif

#if canImport(AppKit)
extension Animation {
    /// Set the timing function and duration on the animation context.
    /// - Parameters:
    ///   - context: The context to modify
    ///   - allowsImplicitAnimation: Whether to enable implicit animations.
    /// - Throws:
    ///    - Error if the animation can't be applied.
    func applyToContext(_ context: NSAnimationContext, allowsImplicitAnimation: Bool) throws {
        guard let timingFunction = self.timingFunction else {
            throw MatchedAnimationError.noTimingFunction
        }
        context.duration = self.duration ?? 0.2
        context.timingFunction = timingFunction
        context.allowsImplicitAnimation = allowsImplicitAnimation
    }
    /// Create a timing function that matches this Animation.
    public var timingFunction: CAMediaTimingFunction? {
        guard let p = self.controlPoints else { return nil }
        return CAMediaTimingFunction(
            controlPoints: Float(p.cp1.x), Float(p.cp1.y), Float(p.cp2.x), Float(p.cp2.y)
        )
    }
}
#endif

enum MatchedAnimationError: Error {
    case noTimingFunction
}

extension Animation {
    var duration: Double? {
        let m = Mirror(reflecting: self)
        guard let base = m.children.first else { return nil }
        let bm = Mirror(reflecting: base.value)
        return bm.children.first?.value as? Double
    }
}

struct ControlPoints: Equatable {
    var cp1: CGPoint
    var cp2: CGPoint
}

extension ControlPoints {
    static var linear: Self {
        .init(
            cp1: .init(x: 0, y: 0),
            cp2: .init(x: 1, y: 1)
        )
    }
}

extension Animation {
    var controlPoints: ControlPoints? {

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
}
