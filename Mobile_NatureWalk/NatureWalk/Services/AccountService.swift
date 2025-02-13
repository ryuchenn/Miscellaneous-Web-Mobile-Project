//
//  AccountHelper.swift
//  NatureWalk
//
//  Created by joeyin on 2025/2/9.
//

import Foundation

class AccountService {
    private static func detail() -> User? {
        guard let value: Data = UserDefaultsHelper.get(.ACCOUNT) else {
            return nil
        }

        return try? JSONDecoder().decode(User.self, from: value)
    }

    static func login(email: String, password: String) -> Bool {
        if let result = users.first(where: { $0.email.lowercased() == email.lowercased() && $0.password == password }) {
            let user = User(id: result.id, email: result.email, name: result.name)
            if let encodedData = try? JSONEncoder().encode(user) {
                UserDefaultsHelper.set(.ACCOUNT, encodedData)
                return true
            }
        }
        return false
    }

    static func logout() {
        UserDefaultsHelper.remove(.ACCOUNT)
    }
    
    static func rememberMe(enable: Bool = false, email: String, password: String) {
        if (enable) {
            let user = LoginForm(email: email, password: password, remember: enable)
            if let encodedData = try? JSONEncoder().encode(user) {
                UserDefaultsHelper.set(.LOGIN_FORM, encodedData)
            }
        } else {
            UserDefaultsHelper.remove(.LOGIN_FORM)
        }
    }
    
    static func getRememberedLoginData() -> LoginForm? {
        guard let value: Data = UserDefaultsHelper.get(.LOGIN_FORM) else {
            return nil
        }

        return try? JSONDecoder().decode(LoginForm.self, from: value)
    }

    static func isLoggedIn() -> Bool {
        return detail()?.name.isEmpty == false
    }

    static func name() -> String {
        return detail()?.name ?? ""
    }

    static func email() -> String {
        return detail()?.email ?? ""
    }
    
    static func avatar() -> String {
        return "https://avatar.iran.liara.run/username?username=\(name())"
    }
    
    static func id() -> Int {
        return detail()?.id ?? 0
    }
}
