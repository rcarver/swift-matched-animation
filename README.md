# MatchedAnimation

Match animations in SwiftUI and UIKit/AppKit.

```swift
/// Draw a box in UIKit
struct BoxView: UIViewRepresentable {
    let size: CGSize
    let position: CGPoint
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        let box = UIView()
        box.backgroundColor = .red
        view.addSubview(box)
        return view
    }
    func updateUIView(_ view: UIView, context: Context) {
        // 🌟 Wrap changes to UIKit with UIPropertyAnimator that matches the SwiftUI Animation
        withMatchedAnimation(context.transaction.animation) {
            view.subviews.first?.frame = CGRect(origin: position, size: size)
        }
    }
}
```

## Limitations

* FIXME: bezier conversions are not quite right 
* Currently only supports easing animations, not spring animations

## License

This library is released under the MIT license. See LICENSE for details.
