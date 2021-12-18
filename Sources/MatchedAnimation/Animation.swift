import SwiftUI

#if canImport(UIKit)
extension Animation {
    /// Create a UIPropertyAnimator that matches this Animation.
    ///
    /// Returns nil if anmy required values of the animation couldn't be found.
    public var uiPropertyAnimator: UIViewPropertyAnimator? {
        let p = parse()
        guard let duration = p.duration,
              let controlPoints = p.controlPoints
        else { return nil }
        return UIViewPropertyAnimator(
            duration: duration,
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
    public func applyToContext(_ context: NSAnimationContext, allowsImplicitAnimation: Bool) throws {
        let p = parse()
        guard let duration = p.duration else {
            throw MatchedAnimationError.missingDuration
        }
        guard let controlPoints = p.controlPoints else {
            throw MatchedAnimationError.missingContolPoints
        }
        context.duration = duration
        context.timingFunction = CAMediaTimingFunction(controlPoints: controlPoints)
        context.allowsImplicitAnimation = allowsImplicitAnimation
    }
}
extension CAMediaTimingFunction {
    init(controlPoints p: ControlPoints) {
        self.init(controlPoints: Float(p.cp1.x), Float(p.cp1.y), Float(p.cp2.x), Float(p.cp2.y))
    }
}
#endif

enum MatchedAnimationError: Error {
    case missingDuration
    case missingContolPoints
}

extension Animation {

    func parse() -> ParsedAnimation {
        var output = ParsedAnimation()
        guard let base = Mirror(reflecting: self).children.first else { return output }
        parseAnimation(&output, mirror: Mirror(reflecting: base.value))
        return output
    }

    /// The duration of the animation, if available.
    var duration: Double? {
        parse().duration
    }

    /// The cubic control points for the animation, if available.
    var controlPoints: ControlPoints? {
        parse().controlPoints
    }
}
