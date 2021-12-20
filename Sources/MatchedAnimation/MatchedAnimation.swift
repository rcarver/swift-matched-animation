import SwiftUI

#if canImport(UIKit)
/// Perform the body with animation, matching animations in UIKit and SwiftUI.
///
/// If the animation cannot be matched, no animation is performed.
public func withMatchedAnimation(_ animation: Animation? = .default, _ body: @escaping () -> Void) {
    guard let animation = animation,
          let animator = animation.uiPropertyAnimator
    else {
        return body()
    }
    animator.addAnimations(body)
    withAnimation(animation) {
        animator.startAnimation()
    }
}
#endif

#if canImport(AppKit)
/// Perform the body with animation, matching animations in AppKit and SwiftUI.
///
/// Defaults to implicit animations enabled.
/// If the animation cannot be matched, no animation is performed.
public func withMatchedAnimation(_ animation: Animation?, allowsImplicitAnimation: Bool = true, _ body: @escaping () -> Void) {
    guard let animation = animation else {
        withoutNSAnimation(body)
        return
    }
    NSAnimationContext.runAnimationGroup { context in
        do {
            try animation.applyToContext(
                context,
                allowsImplicitAnimation: allowsImplicitAnimation
            )
            withAnimation(animation, body)
        } catch {
            withoutNSAnimation(body)
        }
    }
}
// Remove default animations that would be used by animator() proxy.
private func withoutNSAnimation(_ body: @escaping () -> Void) {
    NSAnimationContext.runAnimationGroup { context in
        context.duration = 0
        body()
    }
}
#endif
