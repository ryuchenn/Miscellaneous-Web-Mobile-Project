//
//  LoginForm.swift
//  NatureWalk
//
//  Created by joeyin on 2025/2/9.
//

import Foundation

struct LoginForm: Codable {
    let email: String
    let password: String
    let remember: Bool?
}
