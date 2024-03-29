import SwiftUI

public struct RefdsAlertModifier: ViewModifier {
    @Binding private var alert: RefdsAlert.ViewData?
    @State private var isAppear: Bool = false
    private let isBasicAlert: Bool
    
    public init(alert: Binding<RefdsAlert.ViewData?>) {
        self._alert = alert
        if let wrappedValue = alert.wrappedValue {
            isBasicAlert = wrappedValue.style == .basic(wrappedValue.style.basicType, wrappedValue.style.title, wrappedValue.style.message, nil)
        } else {
            isBasicAlert = false
        }
    }
    
    public func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(
                ZStack {
                    mainView()
                }.animation(.spring(), value: alert)
            )
            .onChange(of: alert) { _ in showAlert() }
    }
    
    @ViewBuilder func mainView() -> some View {
        if let alert = alert {
            VStack {
                Spacer()
                HStack(alignment: .center) {
                    Spacer()
                    RefdsAlert(
                        style: alert.style,
                        withBackground: true,
                        primaryAction: .init(title: alert.primaryAction?.title ?? "", action: { alert.primaryAction?.action?(); self.dismissAlert() }),
                        secondaryAction: .init(title: alert.secondaryAction?.title ?? "", action: { alert.secondaryAction?.action?(); self.dismissAlert() })
                    )
                    .padding(.horizontal, isBasicAlert ? 20 : 15)
                    .padding(.bottom, isBasicAlert ? nil : 15)
                    Spacer()
                }
                if isBasicAlert {
                    Spacer()
                }
            }
            .transition(.move(edge: .bottom))
            .background(isBasicAlert ? RefdsColor.secondary.opacity(0.1) : .clear)
        }
    }
    
    private func showAlert() {
        guard let alert = alert else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation { isAppear = true }
        }
        
        var optionalDuration = alert.style.duration ?? (alert.primaryAction == nil && alert.secondaryAction == nil ? 5 : nil)
        
        switch alert.style {
        case .inline(_, _, _): optionalDuration = 5
        default: break
        }
        
        guard let duration = optionalDuration else { return }
        
        if duration > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) { dismissAlert() }
        }
    }
    
    private func dismissAlert() {
        withAnimation { isAppear = false }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation { alert = nil }
        }
    }
}
