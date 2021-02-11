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
    var address: Address?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
        if let _ = address {
            textresult.text.append("Cep: \(address?.cep ?? "") \n")
            textresult.text.append("Logradouro: \(address?.logradouro ?? "") \n")
            textresult.text.append("complemento: \(address?.complemento ?? "") \n")
            textresult.text.append("bairro: \(address?.bairro ?? "") \n")
            textresult.text.append("localidade: \(address?.localidade ?? "") \n")
            textresult.text.append("uf: \(address?.uf ?? "") \n")
            textresult.text.append("ibge: \(address?.ibge ?? "") \n")
            textresult.text.append("gia: \(address?.gia ?? "") \n")
            textresult.text.append("ddd: \(address?.ddd ?? "") \n")
            textresult.text.append("siafi: \(address?.siafi ?? "") \n")
        }
        
    }
}

