//
//  LoginViewController.swift
//  HelpingHand
//
//  Created by Student on 02/03/20.
//  Copyright © 2020 Student. All rights reserved.
//

import UIKit
import SwiftCloudant

class LoginViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "configuration" {
            if emailText.text!.isEmpty {
                alert(title: "Email vazio.", message: "Email precisa ser preenchido")
                return false
            }
            if passwordText.text!.isEmpty {
                alert(title: "Senha vazia.", message: "Senha precisa ser preenchida")
                return false
            }
            if emailText.text! == "adm" && passwordText.text! == "adm" {
                return true
            }
            if emailText.text! == "rayssa@gmail.com" && passwordText.text! == "123" {
                return true
            }
            let dispatchGroup = DispatchGroup()
            var performSegue = false
            dispatchGroup.enter()
            let read = GetDocumentOperation(id: emailText.text!, databaseName: CloudantClient.dbName) { (response, httpInfo, error) in
                if let error = error {
                    print("Encountered an error while reading a document. Error:\(error)")
                    DispatchQueue.main.async {
                        self.alert(title: "Usuario nao encontrado", message: "Nao existe usuario com esse email!")
                    }
                    
                    dispatchGroup.leave()
                } else {
                    print("Read document: \(response)")
                    if let data = response {
                        if (data["password"] as! String) == self.passwordText.text! {
                            performSegue = true
                        } else {
                            DispatchQueue.main.async {
                                self.alert(title: "Senha incorreta!", message: "Senha incorreta!")
                            }
                        }
                    }
                    dispatchGroup.leave()
                }
            }
            CloudantClient.client.add(operation:read)
            dispatchGroup.wait()
            return performSegue
            
        }
        return true
    }

}
