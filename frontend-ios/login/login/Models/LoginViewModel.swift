//
//  LoginViewModel.swift
//  login
//
//  Created by jsdysw on 2022/03/06.
//

import Foundation
import Alamofire

class LoginViewModel: ObservableObject {
    @Published var credentials = Credentials()
    
    struct LoginRequestBody: Codable {
        let email: String
        let password: String
    }

    struct LoginResponse: Codable {
        let accesstoken: String?
        let refreshtoken: String?
        let message: String?
    }
    
    func login(authentication: Authentication) {
        let login = LoginRequestBody(email: credentials.email, password: credentials.password)
        AF.request("http://localhost:3000/login", method: .post, parameters: login, encoder: JSONParameterEncoder.default).responseJSON { response in
            var loginRes: LoginResponse
            do {
                loginRes = try JSONDecoder().decode(LoginResponse.self, from: response.data!)
                
                if response.response?.statusCode == 200 {
                    authentication.updateValidation(success: true)
                    authentication.accesstoken = loginRes.accesstoken ?? ""
                    authentication.refreshtoken = loginRes.refreshtoken ?? ""
                }
                debugPrint(loginRes)
            } catch let error {
                print(error)
            }
        }
    }
}
