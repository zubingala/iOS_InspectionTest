//
//  AuthScreenVC.swift
//  InspectionTest
//
//  Created by Zubin Gala on 12/08/24.
//

import UIKit

class AuthScreenVC: UIViewController {
    

    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var authButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    let authViewModel : AuthViewModel = AuthViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUIForAuth()
        
        authViewModel.authDelegate = self
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func authButtonAction(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        let request = AuthenticationRequest(email: email, password: password)
        authViewModel.authenticateUser(request: request)
    }
    
    
    func setUIForAuth(){
        authButton.setTitle(authViewModel.authenticationType.buttonTitle, for: .normal)
        self.subtitleLabel.text = "Enter the following details to \(authViewModel.authenticationType.buttonTitle)"
        if authViewModel.authenticationType == .register{
            self.loginButton.isHidden = false
            self.registerButton.isHidden = true
        }else{
            self.loginButton.isHidden = true
            self.registerButton.isHidden = false
        }
        
    }
    @IBAction func loginButtonAction(_ sender: UIButton) {
        authViewModel.authenticationType = .login
        setUIForAuth()
    }
    @IBAction func registerButtonAction(_ sender: UIButton) {
        authViewModel.authenticationType = .register
        setUIForAuth()
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension AuthScreenVC: AuthViewModelProtocol {
    //MARK: - UpdateAuthenticationVCProtocol Methods
    func pushToNextController() {
        DispatchQueue.main.async { [weak self] in
            let inspectionVC = InspectionVC(nibName: "InspectionVC", bundle: nil)
            self?.navigationController?.pushViewController(inspectionVC, animated: true)
             
        }
    }
    
    func showAlert(message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.showAlertMessage(message)
        }
    }
}

extension UIViewController {
    func showAlertMessage(_ message: String) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(ok)
        present(alertController, animated: true)
    }
}
