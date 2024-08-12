//
//  AuthViewModel.swift
//  InspectionTest
//
//  Created by Zubin Gala on 12/08/24.
//

import Foundation
protocol AuthViewModelProtocol: AnyObject {
    func pushToNextController()
    func showAlert(message: String)
}
class AuthViewModel {
    //MARK: - stored properties
    var authenticationType: AuthenticationType = .register
    
    weak var authDelegate: AuthViewModelProtocol?
    private let authenticationApiServiceManager = NetworkManager()
    
    func authenticateUser(request: AuthenticationRequest) {
        guard !request.email.isEmpty, !request.password.isEmpty else {
            authDelegate?.showAlert(message: authenticationType.emptyCredentialsMessage)
            return
        }
        
        guard let urlRequest = authenticationType.createRequest(with: request) else { return }
        
        authenticationApiServiceManager.authenticateUser(urlRequest: urlRequest) { [weak self] result in
            guard let wSelf = self else { return }
            switch result {
            case .success:
                wSelf.authDelegate?.pushToNextController()
            case .failure(let error as NSError):
                var message: String
                switch error.code {
                case 400:
                    message = wSelf.authenticationType.error400Message
                case 401:
                    message = wSelf.authenticationType.error401Message
                default:
                    message = error.localizedDescription
                }
                wSelf.authDelegate?.showAlert(message: message)
            }
        }
    }
}
