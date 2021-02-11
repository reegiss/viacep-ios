//
//  Viacep.swift
//  viacep-ios
//
//  Created by Regis Araujo Melo on 11/02/21.
//

import Foundation

let API_ENDPOINT = "https://viacep.com.br/ws/"

public class Viacep {
    
    var cep: String?
    var callbackBlock: ((_ error: Error?, _ address: Address?) -> Void)?
    private var addressResponse: Address?
    
    static var shared: Viacep = {
        let instance = Viacep()
        return instance
    }()

    class public func sharedInstance() -> Viacep? {
        return shared
    }
    
    private init() {}
    
    public convenience init(cep: String?) {
        self.init()
        self.cep = cep
    }
    
    public func hasErrorCep() -> Bool {
        return ((cep?.count ?? 0) != 8)
    }
    
    public func requestCep(_ block: @escaping (_ error: Error?, _ address: Address?) -> Void) {

        callbackBlock = block
        
        ViacepServices.shared.fetchCep(cep: self.cep!) { (result: Result<Address, ViacepServices.APIServiceError>) in
            switch result {
            case .success(let response):
                self.callbackBlock!(nil, response)
            case .failure(let error):
                print(error.localizedDescription)
                self.callbackBlock!(error, nil)
            }
        }

    }
    
}

extension Viacep: NSCopying {
    public func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
