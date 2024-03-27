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
        case receipt
        case waitingView
        case numberPad
        case pinPad
        
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
            case .receipt:
                return "Receipt"
            case .waitingView:
                return "Schermata di attesa"
            case .numberPad:
                return "Numeric pad"
            case .pinPad:
                return "Pin pad"
            }
        }
        
        @ViewBuilder @MainActor
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
                LoadingDemoView()
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
                IntroView(
                    title: "Accetta un bonus ID Pay",
                    subtitle: """
                                Inserisci i dettagli del pagamento e permetti ai tuoi
                                clienti di utilizzare un bonus ID Pay.
                                """,
                    actionTitle: "Accetta bonus ID Pay",
                    action: {
                        print("Inizia flusso bonus")
                    })
            case .receipt:
                ReceiptTicketDemoView()
            case .waitingView:
                EmptyView()
            case .numberPad:
                BonusAmountView(
                    viewModel: BonusAmountViewModel(
                        networkClient: NetworkClient(
                            environment: .development
                        ),
                        initiative: Initiative.mocked
                    )
                )
            case .pinPad:
                CIEPinView(viewModel: CIEPinViewModel(
                    networkClient: NetworkClient(environment: .development),
                    transaction: TransactionModel.mockedSuccessTransaction,
                    verifyCIEResponse: VerifyCIEResponse.mockedSuccessResponse,
                    initiative: Initiative.mocked)
                )
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
    @State var isPresentingWaitingView: Bool = false
    @State var dialogModel: ResultModel?
    @State var codeValue: String?
    @State var showMenu: Bool = false
    @State var showHelp: Bool = false

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
                        .padding(Constants.xsmallSpacing)
                    } else if component.type == .waitingView {
                        Button {
                            isPresentingWaitingView.toggle()
                        } label: {
                            Text(component.type.name)
                                .font(.PAFont.cta)
                                .foregroundColor(.paPrimaryDark)
                                .padding(Constants.xsmallSpacing)
                        }
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
                    Button {
                        showMenu.toggle()
                    } label: {
                        Image(icon: .menu)
                            .foregroundColor(.white)
                    }
                }
            })
        }
        .alert("Thankyou page type", isPresented: $showThankyouPageChoiceAlert) {
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
            onClose: {
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
        .waitingView(
            title: "Attendi autorizzazione",
            subtitle: "Per proseguire è necessario autorizzare l’operazione sull’app IO",
            buttons: [
                ButtonModel(type: .plain, themeType: .info, title: "Annulla", action: {
                isPresentingWaitingView.toggle()
            })],
            isPresenting: $isPresentingWaitingView
        )
        .showSheet(isVisibile: $showMenu) {
            MenuView(showMenu: $showMenu, showHelp: $showHelp)
        }
        .fullScreenCover(isPresented: $showHelp) {
            HelpView()
                .ignoresSafeArea()
        }
    }
    
    private func infoAction() {
        self.dialogModel = ResultModel(
            subtitle: """
                    Se l’importo è diverso rispetto all’avviso,
                    è perché pagoPA aggiorna automaticamente per assicurarti
                    di aver pagato esattamente quanto dovuto ed evitarti così more o altri interessi.
                    """,
            icon: .infoFilled,
            themeType: ThemeType.info,
            buttons: [
                ButtonModel(
                    type: .primary,
                    themeType: .info,
                    title: "Ok",
                    action: {
                        print("Ok")
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
            buttons: [
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
                        print("Esci dal pagamento")
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
            buttons: [
                ButtonModel(
                    type: .primary,
                    themeType: .light,
                    title: "Identificazione con CIE",
                    action: {
                        print("Identificazione con CIE")
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
            subtitle: """
                La spesa è già stata autorizzata, 
                se annulli l’operazione l’importo verrà riaccreditato sull’iniziativa del cittadino.
                """,
            themeType: ThemeType.light,
            buttons: [
                ButtonModel(
                    type: .primary,
                    themeType: .light,
                    title: "Concludi operazione",
                    action: {
                        print("Concludi operazione")
                    }
                ),
                ButtonModel(
                    type: .plain,
                    themeType: .light,
                    title: "Annulla operazione",
                    action: {
                        print("Annulla operazione")
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
#Preview { ComponentsDemoListView()}
