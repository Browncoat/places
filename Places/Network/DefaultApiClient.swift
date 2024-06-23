import Foundation

class DefaultApiClient: NSObject, ApiClient {
    private var session: URLSession?
    
    init(session: URLSession? = nil) {
        super.init()
        self.session = session ?? URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    }
    
    func get(path: String) async throws -> Data {
        guard let url = URL(string: path) else {
            throw ApiClientError.malformedURL
        }
        
        let request = URLRequest(url: url)
        
        do {
            let (data, _) = try await session!.data(for: request)
            return data
        } catch {
            throw ApiClientError.networkError
        }
    }
}

extension DefaultApiClient: URLSessionDelegate {
    // MARK: URLSessionDelegate
    // needed to bypass zScaler proxy SSL error on simulator
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge) async -> (URLSession.AuthChallengeDisposition, URLCredential?) {
        let authenticationMethod = challenge.protectionSpace.authenticationMethod
        if authenticationMethod == NSURLAuthenticationMethodServerTrust {
            // Evaluate server certificate
            // unwrap serverTrust and handle it being nil.
            var result = SecTrustResultType(rawValue: 0)!
            // @typedef SecTrustResultType
            // @abstract Specifies the trust result type.
            // @discussion SecTrustResultType results have two dimensions.They specify both whether evaluation succeeded and whether this is because of a user decision.
            if let serverTrust = challenge.protectionSpace.serverTrust {
                SecTrustEvaluate(serverTrust, &result)
                switch result {
                case .unspecified,.recoverableTrustFailure:
                    return (URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: serverTrust))
                    
                case .proceed:
                    return (URLSession.AuthChallengeDisposition.performDefaultHandling, nil)

                default: break
                }
            }
        }
        
        return (URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
    }
}
