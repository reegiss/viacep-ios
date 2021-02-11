//
//  Address.swift
//  viacep-ios
//
//  Created by Regis Araujo Melo on 02.02.2021.
//  Email regis@r3tecnologia.net
//  Copyright © 2021 R3Tecnologia.net. All rights reserved.
//


import Foundation

// MARK: - Address
public struct Address: Codable {
    public let cep: String
    public let logradouro: String
    public let complemento: String
    public let bairro: String
    public let localidade: String
    public let uf: String
    public let ibge: String
    public let gia: String
    public let ddd: String
    public let siafi: String

    enum CodingKeys: String, CodingKey {
        case cep
        case logradouro
        case complemento
        case bairro
        case localidade
        case uf
        case ibge
        case gia
        case ddd
        case siafi
    }
}
