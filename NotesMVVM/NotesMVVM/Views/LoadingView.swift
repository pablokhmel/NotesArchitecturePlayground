import SwiftUI

struct LoadingView: View {
    @Binding var loadingState: LoadingState<Any>
    let errorAlertPrimaryAction: (() -> Void)?
    let errorAlertSecondaryAction: (() -> Void)?
    
    var body: some View {
        ZStack {
            switch loadingState {
            case .idle, .loaded, .error:
                EmptyView()
            case .loading:
                ZStack {
                    Color.black.opacity(0.2)
                        .ignoresSafeArea()
                    ZStack {
                        Color.white
                            .frame(width: 210, height: 120)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        VStack(spacing: 12) {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .scaleEffect(1.5)
                            Text("Loading...")
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
        }
        .alert("Error", isPresented: loadingState.isError) {
            Button("OK") {
                errorAlertPrimaryAction?()
                loadingState = .idle
            }
            Button("Retry") {
                errorAlertSecondaryAction?()
                loadingState = .idle
            }
        } message: {
            Text(loadingState.errorMessage ?? "Unknown error")
        }
    }
}

extension LoadingState {
    fileprivate var isError: Binding<Bool> {
        Binding {
            if case .error = self { return true }
            return false
        } set: { _ in }
        
    }
    
    fileprivate var errorMessage: String? {
        if case .error(let e) = self {
            return e.localizedDescription
        }
        
        return nil
    }
}

#Preview {
    let error = NSError(domain: "Error domain", code: 1, userInfo: nil)
    LoadingView(loadingState: .init(get: {
        return .error(error)
    }, set: { _ in })) {
        print("OK pressed")
    } errorAlertSecondaryAction: {
        print("Retry pressed")
    }
}
