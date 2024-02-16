//
//  DialogView.swift
//
//
//  Created by Pier Domenico Bonamassa on 18/12/23.
//

import SwiftUI

public struct DialogView: View {
    
    var dialogModel: ResultModel
    @Binding var isPresenting: Bool
    var onClose: (() -> Void)?
    
    public init(dialogModel: ResultModel, isPresenting: Binding<Bool>, onClose: (() -> Void)? = nil) {
        self.dialogModel = dialogModel
        _isPresenting = isPresenting
        self.onClose = onClose
    }
    
    public var body: some View {
        ZStack {
//            if isPresenting {
                Color.overlay75
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    HStack {
                        Spacer()
                        if let onClose = onClose{
                            Button() {
                                isPresenting = false
                                onClose()
                            } label: {
                                Image(icon: .close)
                                    .foregroundColor(dialogModel.theme.primaryButtonBkgColor)
                            }
                            .padding()
                            .foregroundColor(.paPrimary)
                            .cornerRadius(Constants.radius1)
                        }
                    }
                    .frame(minHeight: Constants.mediumSpacing)
                    .padding(Constants.xsmallSpacing/2)
                    
                    ResultView(
                        result:
                            ResultModel(
                                title: dialogModel.title,
                                subtitle: dialogModel.subtitle,
                                icon: dialogModel.icon,
                                themeType: dialogModel.themeType,
                                buttons: dialogModel.buttons,
                                showLoading:dialogModel.showLoading
                            )
                    )
                    .padding(.bottom, Constants.largeSpacing)
                }
                .background(dialogModel.theme.backgroundColor)
                .cornerRadius(Constants.radius2)
                .padding(Constants.mediumSpacing)
//            }
        }
//        .animation(.spring(duration: 0.1), value: isPresenting)
        
    }
}


//MARK: - Dialog Modifier

struct DialogModifier: ViewModifier {
    var dialogModel: ResultModel
    @Binding var isPresenting: Bool
    @State private var showDialog: Bool = false
    var onClose: (() -> Void)?
    
    func body(content: Content) -> some View {
        content
        .onChange(of: isPresenting) { newValue in
            var transaction = Transaction()
            transaction.disablesAnimations = true
            withTransaction(transaction) {
                showDialog = newValue
            }
        }
        .fullScreenCover(isPresented: $showDialog) {
            DialogView(dialogModel: dialogModel, isPresenting: $isPresenting, onClose: onClose)
        }
        
    }
}

extension View {
    public func dialog(dialogModel:ResultModel, isPresenting: Binding<Bool>, onClose: (() -> Void)? = nil) -> some View {
        modifier(DialogModifier(dialogModel: dialogModel, isPresenting: isPresenting, onClose: onClose))
    }
}

// MARK: - Demo Views
public struct WarningDialogDemo: View {
    public init() {}
    public var body: some View {
        DialogView(
            dialogModel:
                ResultModel(
                    title: "Codice errato!",
                    subtitle: "Hai a disposizione ancora 2 tentativi.",
                    themeType: ThemeType.warning,
                    buttons:[
                        ButtonModel(
                            type: .primary,
                            themeType: .warning,
                            title: "Riprova",
                            action: {
                                print("Riprova")
                            }
                        ),
                        ButtonModel(
                            type: .plain,
                            themeType: .warning,
                            title: "Esci dal pagamento",
                            action: {
                                print("Accetta nuovo bonus")
                            }
                        )
                    ]
                ),
            isPresenting: .constant(true)
        )
    }
}

public struct InfoDialogDemo: View {
    public init() {}
    public var body: some View {
        DialogView(
            dialogModel:
                ResultModel(
                    title: "prova dialog",
                    subtitle: "subtitle",
                    themeType: ThemeType.info,
                    buttons:[
                        ButtonModel(
                            type: .primary,
                            themeType: .info,
                            title: "Riprova",
                            action: {
                                print("Riprova")
                            }
                        ),
                        ButtonModel(
                            type: .secondaryBordered,
                            themeType: .info,
                            title: "Accetta nuovo bonus",
                            action: {
                                print("Accetta nuovo bonus")
                            }
                        )
                    ]
                ),
            isPresenting: .constant(true)
        )
    }
}

public struct InfoPayDialogDemo: View {
    public init() {}
    public var body: some View {
        DialogView(
            dialogModel:
                ResultModel(
                    subtitle: "Se l’importo è diverso rispetto all’avviso, è perché pagoPA aggiorna automaticamente per assicurarti di aver pagato esattamente quanto dovuto ed evitarti così more o altri interessi.",
                    icon: .infoFilled,
                    themeType: ThemeType.info,
                    buttons:[
                        ButtonModel(
                            type: .primary,
                            themeType: .info,
                            title: "Medium",
                            action: {
                                print("Riprova")
                            })
                    ]
                ),
            isPresenting: .constant(true)
        )
    }
}

public struct AuthDialogDemo: View {
    public init() {}
    public var body: some View {
        DialogView(
            dialogModel:
                ResultModel(
                    title: "Come vuoi identificarti?",
                    themeType: ThemeType.light,
                    buttons:[
                        ButtonModel(
                            type: .primary,
                            themeType: .light,
                            title: "Identificazione con CIE",
                            action: {
                                print("Riprova")
                            }
                        ),
                        ButtonModel(
                            type: .primaryBordered,
                            themeType: .light,
                            title: "Accetta nuovo bonus",
                            icon: .io,
                            action: {
                                print("Accetta nuovo bonus")
                            }
                        )
                    ]
                ),
            isPresenting: .constant(true)) {
                print("test")
            }
    }
}

public struct AbortDialogDemo: View {
    
    @State var showDialog: Bool = true
    
    public init() {}
    public var body: some View {
        DialogView(dialogModel:
                    ResultModel(
                        title: "Vuoi annullare la spesa del bonus ID Pay?",
                        subtitle: "La spesa è già stata autorizzata, se annulli l’operazione l’importo verrà riaccreditato sull’iniziativa del cittadino.",
                        themeType: ThemeType.light,
                        buttons:[
                            ButtonModel(
                                type: .primary,
                                themeType: .light,
                                title: "Concludi operazione",
                                action: {
                                    print("Riprova")
                                }
                            ),
                            ButtonModel(
                                type: .plain,
                                themeType: .light,
                                title: "Annulla operazione",
                                action: {
                                    showDialog = false
                                    print("Accetta nuovo bonus")
                                }
                            )
                        ]
                    ),
                   isPresenting: $showDialog
        )
    }
}

// MARK: - Previews

#Preview("ABORT") {
    AbortDialogDemo()
}

#Preview("IDENTIFICATION") {
    AuthDialogDemo()
}

#Preview("INFO_PAY") {
    InfoPayDialogDemo()
}

#Preview("INFO") {
    InfoDialogDemo()
}

#Preview("WARNING") {
    WarningDialogDemo()
}
