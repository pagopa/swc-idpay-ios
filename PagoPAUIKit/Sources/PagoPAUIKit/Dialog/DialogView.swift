//
//  DialogView.swift
//
//
//  Created by Pier Domenico Bonamassa on 18/12/23.
//

import SwiftUI

public struct DialogView: View {
    
    var dialogModel: ResultModel
    var onClose: (() -> Void)?
    
    public init(dialogModel: ResultModel, onClose: (() -> Void)? = nil) {
        self.dialogModel = dialogModel
        self.onClose = onClose
    }
        
    public var body: some View {
        ZStack {
            Color.overlay75
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
               
                HStack {
                    Spacer()
                    if let onClose = onClose{
                        Button() {
                            withAnimation {
                                onClose()
                            }
                        }label: {
                            Image(systemName: "xmark")
                                .foregroundColor(dialogModel.theme.titleColor)
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
                            showLoading:dialogModel.showLoading)
                        
                )
                .padding(.bottom, Constants.largeSpacing)
            }
            .background(dialogModel.theme.backgroundColor)
            .cornerRadius(16)
            .padding(Constants.mediumSpacing)
            
        }
        
    }
}


//MARK: - Dialog Modifier

struct DialogModifier: ViewModifier {
    var dialogModel: ResultModel
    var onClose: (() -> Void)?
    @Binding var isPresenting: Bool
    
    func body(content: Content) -> some View {
        content
            .overlay {
            if isPresenting {
                DialogView(dialogModel: dialogModel, onClose: onClose)
            }
        }
    }
}

extension View {
    public func dialog(dialogModel:ResultModel, onClose: (() -> Void)? = nil, isPresenting: Binding<Bool>) -> some View {
        modifier(DialogModifier(dialogModel: dialogModel, onClose: onClose, isPresenting: isPresenting))
    }
}


public struct WarningDialogDemo: View {
    public init() {}
    public var body: some View {
        DialogView(dialogModel:
                    ResultModel(
                        title: "Codice errato!",
                        subtitle: "Hai a disposizione ancora 2 tentativi.",
                        themeType: ThemeType.warning,
                        buttons:
                            [ButtonModel(
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
                    )
        )
    }
}

public struct InfoDialogDemo: View {
    public init() {}
    public var body: some View {
        DialogView(dialogModel:
                    ResultModel(
                        title: "prova dialog",
                        subtitle: "subtitle",
                        themeType: ThemeType.info,
                        buttons:
                            [ButtonModel(
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
                    )
        )
    }
}

public struct InfoPayDialogDemo: View {
    public init() {}
    public var body: some View {
        DialogView(dialogModel:
                    ResultModel(
                        subtitle: "Se l’importo è diverso rispetto all’avviso, è perché pagoPA aggiorna automaticamente per assicurarti di aver pagato esattamente quanto dovuto ed evitarti così more o altri interessi.",
                        icon: .infoFilled,
                        themeType: ThemeType.info,
                        buttons:
                            [ButtonModel(
                                type: .primary,
                                themeType: .info,
                                title: "Medium",
                                action: {
                                    print("Riprova")
                                }
                            )]
                    )
        )
    }
}

public struct AuthDialogDemo: View {
    public init() {}
    public var body: some View {
        DialogView(dialogModel:
                    ResultModel(
                        title: "Come vuoi identificarti?",
                        themeType: ThemeType.light,
                        buttons:[ButtonModel(
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
                    )) {
                        print("test")
                    }
    }
}

public struct AbortDialogDemo: View {
    public init() {}
    public var body: some View {
        DialogView(dialogModel:
                    ResultModel(
                        title: "Vuoi annullare la spesa del bonus ID Pay?",
                        subtitle: "La spesa è già stata autorizzata, se annulli l’operazione l’importo verrà riaccreditato sull’iniziativa del cittadino.",
                        themeType: ThemeType.light,
                        buttons:[ButtonModel(
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
                                        print("Accetta nuovo bonus")
                                    }
                                 )
                        ]
                    )
        )
    }
}

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
