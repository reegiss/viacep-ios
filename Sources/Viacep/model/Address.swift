//
//  Address.swift
//  viacep-ios
//
//  Created by Regis Araujo Melo on 02.02.2021.
//  Email regis@r3tecnologia.net
//  Copyright © 2021 R3Tecnologia.net. All rights reserved.
//

import Foundation

/// Represents a Brazilian address from the ViaCEP API
///
/// Contains postal code (CEP) and related address information
/// returned from the ViaCEP web service.
public struct Address: Codable, Sendable {
    
    /// Postal code (CEP) in format: XXXXX-XXX
    public let cep: String
    
    /// Street name (logradouro)
    public let logradouro: String
    
    /// Address complement
    public let complemento: String
    
    /// Neighborhood (bairro)
    public let bairro: String
    
    /// City name (localidade)
    public let localidade: String
    
    /// State code (UF)
    public let uf: String
    
    /// IBGE code for the municipality
    public let ibge: String
    
    /// GIA code (São Paulo state tax identifier)
    public let gia: String
    
    /// Area code (DDD)
    public let ddd: String
    
    /// SIAFI code (federal government identifier)
    public let siafi: String
    
    public init(
        cep: String,
        logradouro: String = "",
        complemento: String = "",
        bairro: String = "",
        localidade: String = "",
        uf: String = "",
        ibge: String = "",
        gia: String = "",
        ddd: String = "",
        siafi: String = ""
    ) {
        self.cep = cep
        self.logradouro = logradouro
        self.complemento = complemento
        self.bairro = bairro
        self.localidade = localidade
        self.uf = uf
        self.ibge = ibge
        self.gia = gia
        self.ddd = ddd
        self.siafi = siafi
    }
}
