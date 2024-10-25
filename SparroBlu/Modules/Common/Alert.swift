//
//  Alert.swift
//  SparroBlu
//
//  Created by Thomas Rademaker on 8/31/23.
//

import SwiftUI
import AtProtocol

extension View {
    func alert(_ errorMessage: Binding<ErrorMessage?>) -> some View {
        let binding = Binding(
            get: { errorMessage.wrappedValue != nil },
            set: { isPresented in
                if !isPresented {
                    errorMessage.wrappedValue = nil
                }
            }
        )
        
        guard let errorMessage = errorMessage.wrappedValue else { return alert(Text(""), isPresented: binding, actions: { Button("OK") {} }) }
        return alert(Text(errorMessage.message ?? ""), isPresented: binding, actions: { Button("OK") {} })
    }
}
