//
//  ViewController.swift
//  viacep-ios
//
//  Created by Regis Araujo Melo on 02.02.2021.
//  Email regis@r3tecnologia.net
//  Copyright © 2021 R3Tecnologia.net. All rights reserved.
//

import UIKit
import viacep_ios

class ViewController: UIViewController {
    
    @IBOutlet weak var cep: UITextField!
    @IBOutlet weak var textresult: UITextView!
    
    private let viacepClient = ViacepClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func findCep(_ sender: Any) {
        guard let cepText = cep.text, !cepText.isEmpty else {
            showError("Please enter a CEP")
            return
        }
        
        // Validate CEP format
        guard ViacepClient.isValidCEP(cepText) else {
            showError("Invalid CEP format. Please enter 8 digits.")
            return
        }
        
        // Use modern async/await with Task
        Task {
            do {
                let address = try await viacepClient.fetchAddress(cep: cepText)
                await showResult(address)
            } catch let error as ViacepError {
                await showError(error.localizedDescription ?? "Unknown error occurred")
            } catch {
                await showError("Error: \(error.localizedDescription)")
            }
        }
    }
    
    @MainActor
    private func showResult(_ address: Address) {
        textresult.text = """
        CEP: \(address.cep)
        Logradouro: \(address.logradouro)
        Complemento: \(address.complemento)
        Bairro: \(address.bairro)
        Localidade: \(address.localidade)
        UF: \(address.uf)
        IBGE: \(address.ibge)
        GIA: \(address.gia)
        DDD: \(address.ddd)
        SIAFI: \(address.siafi)
        """
    }
    
    @MainActor
    private func showError(_ message: String) {
        textresult.text = "Error: \(message)"
    }
}

// MARK: - Legacy Implementation (Commented for reference)

/*
 // Old callback-based approach:
 
 @IBAction func findCep(_ sender: Any) {
     let viaCep = Viacep(cep: cep.text)
     if viaCep.hasErrorCep() {
         debugPrint("Error format cep")
     } else {
         viaCep.requestCep( {(error, address) -> Void in
             if (error != nil) {
                 debugPrint("erro = \(error.debugDescription)")
             } else {
                 debugPrint(address.debugDescription)
                 self.address = address
                 DispatchQueue.main.async(execute: {
                     self.showResult(self.address)
                 })
             }
         })
     }
 }
 
 private func showResult(_ address: Address?) {
     if let address = address {
         textresult.text.append("Cep: \(address.cep) \n")
         textresult.text.append("Logradouro: \(address.logradouro) \n")
         textresult.text.append("complemento: \(address.complemento) \n")
         textresult.text.append("bairro: \(address.bairro) \n")
         textresult.text.append("localidade: \(address.localidade) \n")
         textresult.text.append("uf: \(address.uf) \n")
         textresult.text.append("ibge: \(address.ibge) \n")
         textresult.text.append("gia: \(address.gia) \n")
         textresult.text.append("ddd: \(address.ddd) \n")
         textresult.text.append("siafi: \(address.siafi) \n")
     }
 }
 */
