//
//  LoginView.swift
//  atprosphere
//
//  Created by Thomas Rademaker on 8/28/23.
//

import SwiftUI
import SwiftData
import AtProtocol

struct LoginView: View {
    @Environment(OnboardingState.self) private var state
    @Environment(Services.self) private var services
    @State private var userName = ""
    @State private var password = ""
    @State private var loginTrigger = PlainTaskTrigger()
    @State private var createAccountTrigger = PlainTaskTrigger()
    @FocusState private var focusedField: FocusedField?
    @State private var requestInProgress = false
    @State private var errorMessage: ErrorMessage?
    @State private var server: OnboardingState.Server = .bluesky
    
    
    @Query private var sessions: [ACSession]
    
    enum FocusedField {
        case username, password
    }
    
    var body: some View {
        VStack {
            Spacer()
            Text("let's sign you in")
                .font(.largeTitle)
                .foregroundStyle(.primaryBlack)
            
            HStack {
                Text("Server")
                    .font(.system(size: 12, weight: .semibold))
                Spacer()
            }
            .padding(.horizontal)
            
            Menu(content: {
                Picker("server options", selection: $server) {
                    Text(OnboardingState.Server.bluesky.title)
                        .tag(OnboardingState.Server.bluesky)
                    Text(OnboardingState.Server.staging.title)
                        .tag(OnboardingState.Server.staging)
                }
            }, label: {
                Color.clear
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
            })
            .background(
                TextField("server", text: .constant(""), prompt: Text("\(Image(systemName: "network")) \(server.title)"))
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
            )
            
            HStack {
                Text("Account")
                    .font(.system(size: 12, weight: .semibold))
                Spacer()
            }
            .padding([.horizontal, .top])
            
            TextField("Username or email", text: $userName, prompt: Text("\(Image(systemName: "person")) username or email address"))
                .textFieldStyle(.roundedBorder)
                .submitLabel(.next)
                .focused($focusedField, equals: .username)
                .padding([.horizontal, .bottom])
            
            SecureField("password", text: $password, prompt: Text("\(Image(systemName: "lock")) password"))
                .textFieldStyle(.roundedBorder)
                .keyboardType(.default)
                .submitLabel(.go)
                .focused($focusedField, equals: .password)
                .padding(.horizontal)
            Spacer()
            
            HStack {
                Text("Don't have an account?")
                    .foregroundStyle(.primaryBlack.opacity(0.85))
                Button("create account", action: triggerCreateAccount)
                    .bold()
                    .foregroundStyle(.primaryBlack)
            }
            .font(.footnote)
            
            Button(action: triggerLogin) {
                if requestInProgress {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.primaryWhite)
                } else {
                    Text("sign in")
                }
            }
            .buttonStyle(.commonButton)
            .disabled(requestInProgress)
            .padding()
        }
        .fullScreenColorView()
        .navBar(showBackButton: true)
        .task($loginTrigger) { await login() }
        .task($createAccountTrigger) { createAccount() }
        .alert($errorMessage)
        .onSubmit { updateFocusState() }
        .onAppear { focusedField = .username }
    }
    
    private func updateFocusState() {
        switch focusedField {
        case .username:
            focusedField = .password
        case .password:
            triggerLogin()
        case .none:
            focusedField = .username
        }
    }
    
    private func login() async {
        defer { requestInProgress = false }
        requestInProgress = true
        await services.run.update(hostURL: server.hostURL)
        errorMessage = await services.run.login(identifier: userName, password: password)
    }
    
    private func triggerLogin() {
        loginTrigger.trigger()
    }
    
    private func triggerCreateAccount() {
        createAccountTrigger.trigger()
    }
    
    private func createAccount() {
        state.goToCreateAccount()
    }
}

#Preview {
    NavigationStack {
        LoginView()
            .environment(OnboardingState(parentState: .init()))
            .setupServices()
    }
}
