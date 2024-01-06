import SwiftUI

struct ContentView: View {
    
    @State var screenWidth: Double = 0.0;
    @State var screenHeight: Double = 0.0;
    @State var text: String = "Shake me";
    
    let items = [
        "Of course!",
        "No chance.",
        "Slip me a $20. Then yes.",
        "Mayyybe.",
        "Shake me again baby.",
        "Ask again next year.",
        "Sorry. Didn't catch that."
    ]
    
    func randomItem() -> String {
            guard !items.isEmpty else {
                return "No items"
            }
            let randomIndex = Int.random(in: 0..<items.count)
            return items[randomIndex]
        }
   
    var body: some View {
        GeometryReader { geometry in
        ZStack {
            Background()
            GlowTile_Circular()
            Text(text)
                .lineLimit(nil) // Allows the text to wrap
                .multilineTextAlignment(.center)
                .foregroundColor(.white.opacity(0.65))
                .frame(width: 200, height: 40)
                .onShakeGesture {
                    text = randomItem()
                      }
            //GlowTile()
        }
    }.onAppear {
        screenWidth = UIScreen.main.bounds.size.width
        screenHeight = UIScreen.main.bounds.size.height
        }
    }
}


extension UIDevice {
    static let deviceDidShake = Notification.Name(rawValue: "deviceDidShake")
}

extension UIWindow {
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with: UIEvent?) {
        guard motion == .motionShake else { return }
    
    NotificationCenter.default.post(name: UIDevice.deviceDidShake, object: nil)
  }
}

struct ShakeGestureViewModifier: ViewModifier {
  // 1
  let action: () -> Void
  
  func body(content: Content) -> some View {
    content
      // 2
      .onReceive(NotificationCenter.default.publisher(for: UIDevice.deviceDidShake)) { _ in
        action()
      }
  }
}

extension View {
  public func onShakeGesture(perform action: @escaping () -> Void) -> some View {
    self.modifier(ShakeGestureViewModifier(action: action))
  }
}

struct Background: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.radialGradient(colors: [Color(#colorLiteral(red: 0.2970857024, green: 0.3072845936, blue: 0.4444797039, alpha: 1)), .black], center: .center, startRadius: 1, endRadius: 400))
                .ignoresSafeArea()
            
         
                
                Circle()
                    .foregroundStyle(
                        .linearGradient(colors: [.black.opacity(0), .black.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing)
                        .shadow(.inner(color: .white.opacity(0.5), radius: 0, x: 1, y: 1))
                        .shadow(.inner(color: .black, radius: 5, x: -10, y: -10))
                    )
                    .padding(40)
                
                Circle()
                    .foregroundStyle(
                        .linearGradient(colors: [.black.opacity(0.5), .black.opacity(0.0)], startPoint: .topLeading, endPoint: .bottomTrailing)
                        .shadow(.inner(color: .white.opacity(0.5), radius: 0, x: -1, y: -1))
                        .shadow(.inner(color: .black, radius: 10, x: 10, y: 10))
                    )
                    .padding(60)
            
        
            // VStack
        }
    }
}

struct GlowTile: View {
    
    @State var rotation: CGFloat = 0.0
        
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .frame(width: 150, height: 150)
                .foregroundColor(Color(.black))
                .shadow(color: .white.opacity(0.2), radius: 10)
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .frame(width: 200, height: 210)
                .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color(.pink),Color(.blue)]), startPoint: .top, endPoint: .bottom))
                .rotationEffect(.degrees(rotation))
                .mask(RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(lineWidth: 1)
                    .frame(width: 150, height: 150)
                    
                )
        }.onAppear {
            withAnimation(.linear(duration: 10).repeatForever(autoreverses: false)) {
                rotation = 630
            }
        }
        
    }
}

struct GlowTile_Circular: View {
    
    @State var rotation: CGFloat = 0.0
        
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 200, height: 200)
                .foregroundColor(Color(.black))
                .shadow(color: .white.opacity(0.2), radius: 10)
            Circle()
                .frame(width: 300, height: 300)
                .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color(.pink),Color(.blue)]), startPoint: .top, endPoint: .bottom))
                .rotationEffect(.degrees(rotation))
                .mask(Circle()
                    .stroke(lineWidth: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
                    .frame(width: 205, height: 205)
                    
                )
        }.onAppear {
            withAnimation(.linear(duration: 10).repeatForever(autoreverses: false)) {
                rotation = 630
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

