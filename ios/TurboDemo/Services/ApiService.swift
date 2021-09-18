//
//  ApiService.swift
//  TurboDemo
//
//  Created by Dane Wilson on 9/17/21.
//

import Foundation
import KeychainAccess
import WebKit

class APIService {
    static let shared = APIService()
    static var keychain = Keychain(service: "Turbo-Credentials")
    
    var url = Endpoints.rootURL.appendingPathComponent("api/auth")
    
    enum ApiResponseError: Error, LocalizedError, Identifiable {
        case invalidCredentials
        case unUnprocessabledEntity
        
        var id: String {
            self.localizedDescription
        }
        
        var errorDescription: String? {
            switch self {
            case .invalidCredentials:
                return NSLocalizedString("Either your email or password are incorrect. Please try again", comment: "")
            case .unUnprocessabledEntity:
                return NSLocalizedString("Unprocessable entity", comment: "")
            }
            
        }
    }
    
    private var request: URLRequest {
        var request = URLRequest(url: url)
        print("TurboAppDebug: creating request to \(url)")
        request.httpMethod = "POST"

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("TurboApp (Turbo Native)", forHTTPHeaderField: "User-Agent")
        
        if let token = APIService.keychain["access-token"] {
            var request = URLRequest(url: url)
            request.setValue("Bearer: \(token)", forHTTPHeaderField: "Authorization")
        }

        return request
    }
    
    private static func buildRequest(path: String, method: String = "GET") -> URLRequest {
        var request = URLRequest(url: Endpoints.rootURL.appendingPathComponent(path))
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("TurboApp (Turbo Native)", forHTTPHeaderField: "User-Agent")

        if let token = keychain["access-token"] {
            request.setValue("Bearer: \(token)", forHTTPHeaderField: "Authorization")
        }

        return request
    }
    
    static func post(path: String, data: [String: Any], options: [String: Any], completion: @escaping (Result<Bool, ApiResponseError>, [String: Any]) -> Void) {
        let request = buildRequest(path: path, method: "POST")

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                error == nil,
                let response = response as? HTTPURLResponse,
                // Ensure the response was successful
                (200 ..< 300).contains(response.statusCode),
//                let headers = response.allHeaderFields as? [String: String],
                let data = data
            else {
                completion(.failure(.invalidCredentials), [String: String]())
                return /* TODO: Handle errors */
            }
            
            completion(.success(true), ["data": data, "status": response.statusCode])
        }.resume()
    }
    
    private struct AccessToken: Decodable {
        let token: String
    }

    func login(credentials: Credentials,
               completion: @escaping (Result<Bool, Authentication.AuthenticationError>) -> Void) {

        print("TurboAppDebug: credentials \(credentials)")
        var request = request
        request.httpBody = try? JSONEncoder().encode(credentials)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            print("TurboAppDebug: sending request \(self.request) with \(String(describing: data))")
            
            // Persist the access token in the secure keychain
            let keychain = Keychain(service: "Turbo-Credentials")

            // TODO: Handle response: persist token and cookies
            guard
                error == nil,
                let response = response as? HTTPURLResponse,
                // Ensure the response was successful
                (200 ..< 300).contains(response.statusCode),
                let headers = response.allHeaderFields as? [String: String],
                let data = data,
                let token = try? JSONDecoder().decode(AccessToken.self, from: data)
            else {
                DispatchQueue.main.async {
                    keychain["access-token"] = nil
                    completion(.failure(.invalidCredentials))
                }
                return /* TODO: Handle errors */
            }
            
            DispatchQueue.main.async {
                // Copy the "Set-Cookie" headers to the shared web view storage
                let cookies = HTTPCookie.cookies(withResponseHeaderFields: headers, for: Endpoints.rootURL)
                HTTPCookieStorage.shared.setCookies(cookies, for: Endpoints.rootURL, mainDocumentURL: nil)
                let cookieStore = WKWebsiteDataStore.default().httpCookieStore
                cookies.forEach { cookie in
                    cookieStore.setCookie(cookie, completionHandler: nil)
                }
                keychain["access-token"] = token.token
                completion(.success(true))
            }
        }.resume()
    }
}
