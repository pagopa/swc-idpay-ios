//
//  ThankyouPage.swift
//
//
//  Created by Pier Domenico Bonamassa on 19/12/23.
//

import SwiftUI

public struct ThankyouPage: View {
    var result: ResultModel
    
    public init(result: ResultModel) {
        self.result = result
    }
    
    public var body: some View {
        ResultView(
            result: result
        )
        .fullScreenBackground(themeType: result.themeType)
    }
}

public struct ErrorThankyouPageDemo: View {
    public init() {}
    public var body: some View {
        ThankyouPage(
            result:
                ResultModel(
                    title: "L'operazione è stata annullata",
                    subtitle: """
                            Abbiamo riscontrato dei problemi con il pagamento, non è stato addebitato alcun importo.
                        """,
                    themeType: .error,
                    buttons: [
                        ButtonModel(
                            type: .primary,
                            themeType: .error,
                            title: "Torna alla home",
                            action: {
                                print("Torna alla home")
                            }
                        )]
                )
        )
        .fullScreenBackground(themeType: .error)
    }
}

public struct WarningThankyouPageDemo: View {
    public init() {}
    public var body: some View {
        ThankyouPage(
            result:
                ResultModel(
                    title: "Titolo qualsiasi vvvv Titolo qualsiasi Titolo qualsiasi Titolo qualsiasi",
                    subtitle: """
                            Sottotitolo qulasiasi Sottotitolo qulasiasi ccccc Sottotitolo 
                            qulasiasi Sottotitolo qulasiasi Sottotitolo qulasiasi
                            """,
                    themeType: .warning,
                    buttons: [
                        ButtonModel(
                            type: .primary,
                            themeType: .warning,
                            title: "Accetta nuovo bonus",
                            icon: .star,
                            action: {
                                print("Accetta nuovo bonus")
                            }
                        ),
                        ButtonModel(
                            type: .secondaryBordered,
                            themeType: .warning,
                            title: "Riprova",
                            action: {
                                print("Riprova")
                            }
                        )]
                )
        )
        .fullScreenBackground(themeType: .warning)
    }
}

public struct SuccessThankyouPageDemo: View {
    public init() {}
    public var body: some View {
        ThankyouPage(
            result:
                ResultModel(
                    title: "Grazie, l'operazione è stata eseguita con successo!",
                    themeType: .success,
                    buttons: [
                        ButtonModel(
                            type: .primary,
                            themeType: .success,
                            title: "Continua",
                            icon: .arrowRight,
                            action: {
                                print("Continua")
                            }
                        )]
                )
        )
    }
}

public struct LoadingThankyouPageDemo: View {
    public init() {}
    public var body: some View {
        ThankyouPage(
            result:
                ResultModel(
            title: "L'operazione è stata annullata",
            subtitle: "Abbiamo riscontrato dei problemi con il pagamento, non è stato addebitato alcun importo.",
            themeType: .error,
            buttons: [
                ButtonModel(
                    type: .primary,
                    themeType: .error,
                    title: "Torna alla home",
                    action: {
                        print("Torna alla home")
                    }
                )],
            showLoading: true
            )
        )
    }
}

public struct InfoThankyouPageDemo: View {
    public init() {}
    public var body: some View {
        ResultView(
            result:
                ResultModel(
                    title: "L'operazione è stata presa in carico",
                    subtitle: "Accedi al sito dell’ente per verificare lo stato dell’operazione",
                    themeType: .info,
                    buttons: [
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
                        )]
                )
        )
        .fullScreenBackground(themeType: .info)
    }
}

#Preview("Warning Thankyou Page") {
    WarningThankyouPageDemo()
}

#Preview("Success Thankyou Page") {
    SuccessThankyouPageDemo()
}

#Preview("Error Thankyou Page") {
    ErrorThankyouPageDemo()
}

#Preview("Info Thankyou Page") {
    InfoThankyouPageDemo()
}

#Preview("loading Thankyou Page") {
    LoadingThankyouPageDemo()
}
