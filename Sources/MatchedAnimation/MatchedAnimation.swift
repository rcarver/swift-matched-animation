import SwiftUI

#if canImport(UIKit)
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
public func withMatchedAnimation(_ animation: Animation?, allowsImplicitAnimation: Bool = true, _ body: @escaping () -> Void) {
    guard let animation = animation else {
        return body()
    }    
    NSAnimationContext.runAnimationGroup { context in
        animation.applyToContext(context, allowsImplicitAnimation: allowsImplicitAnimation)
        withAnimation(animation, body)
    }
}
#endif
