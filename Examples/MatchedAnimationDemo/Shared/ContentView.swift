import SwiftUI
import MatchedAnimation

struct ContentView: View {

    @State var flag: Bool = false
    @State var animation: Animation? = .easeInOut(duration: 1)

    var size: CGSize {
        CGSize(width: 40, height: 50)
    }
    func position(in container: CGSize) -> CGPoint {
        CGPoint(
            x: flag ? container.width - self.size.width : 0,
            y: 0
        )
    }

    var body: some View {
        ZStack {
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
                    }
                    .frame(height: self.size.height)
                    .background(Color.primary.opacity(0.1))
                }
            }
            .padding(.vertical, 100)
            HStack {
                Button {
                    withAnimation(animation) {
                        flag.toggle()
                    }
                } label: { Text("Flip") }
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

#if canImport(UIKit)
struct RepresentedBox: UIViewRepresentable {
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
        withMatchedAnimation(context.transaction.animation) {
            view.subviews.first?.frame = CGRect(origin: position, size: size)
        }
    }
}
#endif

#if canImport(AppKit)
struct RepresentedBox: NSViewRepresentable {
    let size: CGSize
    let position: CGPoint
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
            view.subviews.first?.frame = CGRect(origin: position, size: size)
        }
    }
}
#endif
