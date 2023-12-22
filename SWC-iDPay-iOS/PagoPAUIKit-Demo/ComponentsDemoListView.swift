//
//  ComponentsDemoListView.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 01/12/23.
//

import SwiftUI
import PagoPAUIKit

struct Component: Identifiable, Hashable {
    
    let id = UUID()
    let type: ComponentType
    
    enum ComponentType: CaseIterable {
        case buttons
        case divider
        case colors
        case progress
        case loader
        case listItem
        case toastNotification
        case input
        case thankyouPage
        case outro
        case dialog
        case intro
        
        var name: String {
            switch self {
            case .buttons:
                return "Buttons"
            case .divider:
                return "Divider"
            case .colors:
                return "Colors"
            case .progress:
                return "Progress"
            case .loader:
                return "Loader"
            case .listItem:
                return "Items"
            case .toastNotification:
                return "Toast notification"
            case .input:
                return "Input"
            case .thankyouPage:
                return "Thankyou Page"
            case .outro:
                return "Outro"
            case .dialog:
                return "Dialog"
            case .intro:
                return "Intro"
            }
        }
        
        @ViewBuilder
        var viewDestination: some View {
            switch self {
            case .buttons:
                ButtonsDemoView()
            case .divider:
                DividerDemoView()
            case .colors:
                ColorsDemoView()
            case .progress:
                ProgressDemoView()
            case .loader:
                LoadingView()
            case .listItem:
                ItemsDemoView()
            case .toastNotification:
                ToastDemoView()
            case .input:
                InputDemoView()
            case .thankyouPage:
                EmptyView()
            case .outro:
                OutroDemoView()
            case .dialog:
                EmptyView()
            case .intro:
                IntroView(title: "Accetta un bonus ID Pay", subtitle: "Inserisci i dettagli del pagamento e permetti ai tuoi clienti di utilizzare un bonus ID Pay.", actionTitle: "Accetta bonus ID Pay", action: {
                    print("Inizia flusso bonus")
                })
            }
        }
    }
}


struct ComponentsDemoListView: View {
    
    @State var themeType: ThemeType?
    @State var navigateToThankyouPage: Bool = false
    @State var showThankyouPageChoiceAlert: Bool = false
    @State var isPresentingDialog: Bool = false
    @State var isPresentingDialogCode: Bool = false
    @State var dialogModel: ResultModel?
    @State var codeValue: String?
    
    private var components: [Component] =
    Component.ComponentType.allCases.map {
        Component(type: $0)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("UI Kit showcase")
                    .font(.PAFont.h1Hero)
                    .foregroundColor(.white)
                List(components) { component in
                    if component.type == .thankyouPage {
                        Button {
                            showThankyouPageChoiceAlert.toggle()
                        } label: {
                            Text(component.type.name)
                                .font(.PAFont.cta)
                                .foregroundColor(.paPrimaryDark)
                                .padding(Constants.xsmallSpacing)
                        }
                        
                    } else if component.type == .dialog {
                        
                        Menu(component.type.name) {
                            Button("Info Payment", action: infoAction)
                            Button("Warning", action: warningAction)
                            Button("Authentication", action: authAction)
                            Button("Cancel operation", action: abortAction)
                            Button("Code", action: codeAction)
                        }
                        .font(.PAFont.cta)
                        .foregroundColor(.paPrimaryDark)
                        .padding(.leading, Constants.xsmallSpacing)
                        
                    } else {
                        NavigationLink(component.type.name, value: component)
                            .font(.PAFont.cta)
                            .foregroundColor(.paPrimaryDark)
                            .padding(Constants.xsmallSpacing)
                    }
                }
                .listStyle(.plain)
                .navigationDestination(for: Component.self) {
                    $0.type.viewDestination
                        .navigationBarTitleDisplayMode(.inline)
                }
                .navigationDestination(isPresented: $navigateToThankyouPage) {
                    if let themeType {
                        switch themeType {
                        case .error:
                            ErrorThankyouPageDemo()
                        case .success:
                            SuccessThankyouPageDemo()
                        case .info:
                            InfoThankyouPageDemo()
                        case .warning:
                            WarningThankyouPageDemo()
                        default:
                            EmptyView()
                        }
                    } else {
                        EmptyView()
                    }
                }
            }
            .background(Color.paPrimary)
            .navigationBarTitle("", displayMode: .inline)
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button{
                        print("Show menu")
                    } label: {
                        Image(icon: .menu)
                            .foregroundColor(.white)
                    }
                }
                
            })
        }
        .alert("Thankyou page type", isPresented: $showThankyouPageChoiceAlert){
            
            VStack {
                Button("Success") {
                    showThankyouPage(.success)
                }
                Button("Error") {
                    showThankyouPage(.error)
                }
                Button("Info") {
                    showThankyouPage(.info)
                }
                Button("Warning") {
                    showThankyouPage(.warning)
                }
            }
        }
        .dialog(
            dialogModel: self.dialogModel ?? ResultModel.emptyModel,
            isPresenting: $isPresentingDialog,
            onClose:{
                print("Do some action on close")
            }
        )
        .dialogCode(
            title: "Problemi con il QR?",
            subtitle: "Entra sull’app IO, vai nella sezione Inquadra e digita il codice:",
            codeValue: codeValue ?? "",
            isPresenting: $isPresentingDialogCode,
            onClose: {
                print("Do some action on close")
            }
        )
    }
    
    private func infoAction() {
        self.dialogModel = ResultModel(
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
                    }
                )]
        )
        
        isPresentingDialog.toggle()
    }
    
    private func warningAction() {
        self.dialogModel = ResultModel(
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
        )
        
        isPresentingDialog.toggle()
    }
    
    private func authAction() {
        self.dialogModel = ResultModel(
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
        )
        
        isPresentingDialog.toggle()
    }
    
    private func abortAction() {
        self.dialogModel = ResultModel(
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
                        print("Accetta nuovo bonus")
                    }
                )
            ]
        )
        isPresentingDialog.toggle()
    }
    
    private func codeAction() {
        self.codeValue = "A7U8GHI3"
        isPresentingDialogCode.toggle()
    }
    
    private func showThankyouPage(_ themeType: ThemeType) {
        self.themeType = themeType
        navigateToThankyouPage = true
        showThankyouPageChoiceAlert.toggle()
    }
}


#Preview {
    ComponentsDemoListView()
}
