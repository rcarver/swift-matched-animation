import SwiftUI

#if canImport(UIKit)
/// Perform the body in a UIKit animation matching the SwiftUI animation.
public func withMatchedAnimation(_ animation: Animation? = .default, _ body: @escaping () -> Void) {
    guard let animation = animation else {
        return body()
    }
    let animator = animation.uiPropertyAnimator
    animator.addAnimations(body)
    withAnimation(animation) {
        animator.startAnimation()
    }
}
#endif

#if canImport(AppKit)
/// Perform the body in an AppKit animation matching the SwiftUI animation.
///
/// Defaults to implicit animations enabled.
public func withMatchedAnimation(_ animation: Animation?, allowsImplicitAnimation: Bool = true, _ body: @escaping () -> Void) {
    guard let animation = animation else {
        return body()
    }    
    NSAnimationContext.runAnimationGroup { context in
        do {
            try animation.applyToContext(
                context,
                allowsImplicitAnimation: allowsImplicitAnimation
            )
            withAnimation(animation, body)
        } catch {
            body()
        }
    }
}
#endif
