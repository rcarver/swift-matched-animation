import SwiftUI
import MatchedAnimation

struct ContentView: View {

    static let animation: Animation? = .easeInOut(duration: 1)

    @State var flag: Bool = false
    @State var isAnimated: Bool = true

    var size: CGSize {
        CGSize(width: 40, height: 50)
    }

    func position(in container: CGSize) -> CGPoint {
        CGPoint(
            x: flag ? container.width - self.size.width : 0,
            y: 0
        )
    }

    var offset: CGPoint {
        flag ? CGPoint(x: 20, y: 0) : .zero
    }

    var body: some View {
        ZStack {
            VStack {
                VStack(alignment: .leading) {
                    Text("1. SwiftUI position")
                    Text("2. *Kit position")
                    Text("3. SwiftUI position and color")
                    Text("4. *Kit position, SwiftUI color")
                }
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .leading)

                GeometryReader { g in
                    VStack {
                        Group {
                            SwiftUIBox(
                                size: self.size,
                                position: self.position(in: g.size)
                            )
                            RepresentedBox(
                                size: self.size,
                                position: self.position(in: g.size)
                            )
                            Rectangle()
                                .foregroundColor(flag ? .red : .orange)
                                .offset(x: self.offset.x, y: self.offset.y)
                            RepresentedContentBox(
                                offset: self.offset
                            ) {
                                Rectangle()
                                    .foregroundColor(flag ? .red : .orange)
                            }
                        }
                        .frame(height: self.size.height)
                        .background(Color.primary.opacity(0.1))
                    }
                }
                .padding(.vertical, 100)
                // Implicit animations work.
                //.animation(isAnimated ? Self.animation : nil, value: flag)
            }

            VStack {
                Button {
                    // Explicit animations work
                    withAnimation(isAnimated ? Self.animation : nil) {
                        flag.toggle()
                    }
                } label: { Text("Flip") }
                Toggle("Animated", isOn: $isAnimated)
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct SwiftUIBox: View {
    let size: CGSize
    let position: CGPoint
    var body: some View {
        Rectangle()
            .foregroundColor(.blue)
            .frame(width: size.width, height: size.height)
            .position(x: position.x + (size.width/2), y: position.y + (size.height/2))
    }
}

struct RepresentedBox {
    let size: CGSize
    let position: CGPoint
}

struct RepresentedContentBox<Content: View> {
    let offset: CGPoint
    let content: () -> Content
    func makeCoordinator() -> Coordinator {
        Coordinator(model: ViewModel(content: content))
    }
    class Coordinator {
        init(model: ViewModel) {
            self.model = model
        }
        var model: ViewModel
    }
    class ViewModel: ObservableObject {
        init(content: @escaping () -> Content) {
            self.content = content
        }
        @Published var content: () -> Content
    }
    struct ViewWrapper: View {
        @ObservedObject var model: ViewModel
        var body: some View {
            model.content()
        }
    }
}

#if canImport(UIKit)
extension RepresentedBox: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        let box = UIView()
        box.backgroundColor = .red
        view.addSubview(box)
        return view
    }
    func updateUIView(_ view: UIView, context: Context) {
        withMatchedAnimation(context.transaction.animation) {
            view.subviews.first?.frame = CGRect(origin: position, size: size)
        }
    }
}
extension RepresentedContentBox: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIHostingController<ViewWrapper> {
        UIHostingController(rootView: ViewWrapper(model: context.coordinator.model))
    }
    func updateUIViewController(_ controller: UIHostingController<ViewWrapper>, context: Context) {
        withMatchedAnimation(context.transaction.animation) {
            controller.view.frame.origin = offset
            context.coordinator.model.content = content
        }
    }
}
#endif

#if canImport(AppKit)
extension RepresentedBox: NSViewRepresentable {
    func makeNSView(context: Context) -> NSView {
        let view = NSView(frame: .zero)
        let box = NSView()
        box.wantsLayer = true
        box.layer?.backgroundColor = NSColor.red.cgColor
        view.addSubview(box)
        return view
    }
    func updateNSView(_ view: NSView, context: Context) {
        withMatchedAnimation(context.transaction.animation) {
            // Using animator proxy shows that animations are removed from implicit and explicit animations
            view.subviews.first?.animator().frame = CGRect(origin: position, size: size)
        }
    }
}
extension RepresentedContentBox: NSViewControllerRepresentable {
    func makeNSViewController(context: Context) -> NSHostingController<ViewWrapper> {
        NSHostingController(rootView: ViewWrapper(model: context.coordinator.model))
    }
    func updateNSViewController(_ controller: NSHostingController<ViewWrapper>, context: Context) {
        withMatchedAnimation(context.transaction.animation) {
            // Not using animator proxy shows that animations are applied to implicit animations.
            controller.view.frame.origin = offset
            context.coordinator.model.content = content
        }
    }
}
#endif
