//
//  GenericDialogs.swift
//  ConversAI
//
//  Created by Murat ÖZTÜRK on 12.06.2023.
//

import SwiftUI
import Combine

public struct GenericDialog<DialogContent: View>: ViewModifier {
    @Binding var isShowing: Bool
    let cancelOnTapOutside: Bool
    let cancelAction: (() -> Void)?
    let dialogContent: DialogContent
    
    public init(isShowing: Binding<Bool>,
                cancelOnTapOutside: Bool,
                cancelAction: (() -> Void)?,
                @ViewBuilder dialogContent: () -> DialogContent) {
        _isShowing = isShowing
        self.cancelOnTapOutside = cancelOnTapOutside
        self.cancelAction = cancelAction
        self.dialogContent = dialogContent()
    }
    
    public func body(content: Content) -> some View {
        ZStack {
            content
            if isShowing {
                Rectangle()
                    .foregroundColor(Color.black.opacity(0.6))
                    .onTapGesture {
                        if cancelOnTapOutside {
                            cancelAction?()
                            isShowing = false
                        }
                    }
                ZStack {
                    dialogContent
                        .background(RoundedRectangle(cornerRadius: 8)
                                        .foregroundColor(.white))
                }.padding(40)
            }
        }
    }
}

public extension View {
    func genericDialog<DialogContent: View>(isShowing: Binding<Bool>,
                                            cancelOnTapOutside: Bool = true,
                                            cancelAction: (() -> Void)? = nil,
                                            @ViewBuilder dialogContent: @escaping () -> DialogContent) -> some View {
        self.modifier(GenericDialog(isShowing: isShowing,
                                    cancelOnTapOutside: cancelOnTapOutside,
                                    cancelAction: cancelAction,
                                    dialogContent: dialogContent))
    }
    
}

public extension View {
    func progressDialog(isShowing: Binding<Bool>,
                        message: String,
                        progress: Progress) -> some View {
        self.genericDialog(isShowing: isShowing, cancelOnTapOutside: false) {
            HStack(spacing: 10) {
                if #available(iOS 14.0, *) {
                    if progress.isIndeterminate {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    } else {
                        ProgressView(value: Float(progress.completedUnitCount) / Float(progress.totalUnitCount))
                            .progressViewStyle(CircularProgressViewStyle())
                    }
                } else {
                    ActivityIndicator(isAnimating: true)
                }
                Text(message)
            }.padding()
        }
    }
}

public struct ActivityIndicator: UIViewRepresentable {
  public typealias UIView = UIActivityIndicatorView
  public var isAnimating: Bool = true
  public var configuration = { (indicator: UIView) in }

    public init(isAnimating: Bool = true, configuration: ((UIView) -> Void)? = nil) {
        self.isAnimating = isAnimating
        if let configuration = configuration {
            self.configuration = configuration
        }
    }

    public func makeUIView(context: UIViewRepresentableContext<Self>) -> UIView {
        UIView()
        
    }

    public func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<Self>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
        configuration(uiView)
    }
}

public extension View where Self == ActivityIndicator {
    func configure(_ configuration: @escaping (Self.UIView) -> Void) -> Self {
        Self.init(isAnimating: self.isAnimating, configuration: configuration)
    }
}
