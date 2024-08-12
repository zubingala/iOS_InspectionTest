//
//  AuthModel.swift
//  InspectionTest
//
//  Created by Zubin Gala on 12/08/24.
//

import Foundation

struct AuthenticationRequest: Encodable {
    let email: String
    let password: String
}

enum AuthenticationType {
    case register
    case login

    var buttonTitle: String {
        switch self {
        case .register:
            return AppString.register
        case .login:
            return AppString.login
        }
    }

    var error400Message: String {
        return AppString.invalidUserPassword
    }

    var error401Message: String {
        switch self {
        case .register:
            return AppString.alreadyRegistered
        case .login:
            return AppString.invalidCredentials
        }
    }

    var emptyCredentialsMessage: String {
        return AppString.validationError
    }

    private var endpoint: String {
        switch self {
        case .register:
            return Constants.Webservices.baseURL + Constants.Webservices.Endpoints.register
        case .login:
            return Constants.Webservices.baseURL + Constants.Webservices.Endpoints.login
        }
    }

    func createRequest(with credentials: AuthenticationRequest) -> URLRequest? {
        guard let url = URL(string: endpoint) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        do {
            request.httpBody = try JSONEncoder().encode(credentials)
        } catch {
            debugPrint("Failed to encode request body: \(error)")
            return nil
        }

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
}
