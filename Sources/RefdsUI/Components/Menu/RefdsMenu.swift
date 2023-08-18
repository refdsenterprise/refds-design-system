import SwiftUI
import RefdsCore

@available(iOS 16.4, *)
public struct RefdsMenu<Content: View>: View {
    @ViewBuilder private let content: () -> Content
    private let icon: RefdsIconSymbol?
    private let text: String?
    private let font: RefdsText.Style
    
    public init(icon: RefdsIconSymbol?, text: String?, font: RefdsText.Style = .body, content: @escaping () -> Content) {
        self.content = content
        self.icon = icon
        self.text = text
        self.font = font
    }

    public var body: some View {
        HStack(spacing: 15) {
            if let icon = icon {
                RefdsIcon(
                    symbol: icon,
                    color: .accentColor,
                    size: font.value * 1.1,
                    weight: .bold,
                    renderingMode: .hierarchical
                )
            }
            
            if let text = text {
                RefdsText(text, style: font)
            }
            
            Spacer()
            
            Menu { content() } label: {
                RefdsIcon(
                    symbol: .chevronUpChevronDown,
                    color: .secondary.opacity(0.5),
                    size: 15,
                    weight: .bold,
                    renderingMode: .monochrome
                )
            }
        }
    }
}

@available(iOS 16.4, *)
struct RefdsMenu_Previews: PreviewProvider {
    static var previews: some View {
        List {
            RefdsMenu(icon: .random, text: .randomWord, font: .body) {
                ForEach(Array(0 ... 5), id: \.self) { _ in
                    RefdsToggle(isOn: .constant(.random())) {
                        RefdsText(.randomWord)
                    }
                }
            }
        }
    }
}