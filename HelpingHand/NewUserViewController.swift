//
//  NewUserViewController.swift
//  HelpingHand
//
//  Created by Student on 03/03/20.
//  Copyright © 2020 Student. All rights reserved.
//

import UIKit
import SwiftCloudant

class NewUserViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
        
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func save(_ sender: Any) {
        if email.text!.isEmpty {
            alert(title: "Email vazio.", message: "Email precisa ser preenchido")
        }
        if name.text!.isEmpty {
            alert(title: "Nome vazio.", message: "Nome precisa ser preenchido")
        }
        if password.text!.isEmpty {
            alert(title: "Senha vazia.", message: "Senha precisa ser preenchida")
        }
        let create = PutDocumentOperation(id: email.text, body: ["password": password.text, "name": name.text], databaseName: CloudantClient.dbName) {(response, httpInfo, error) in
            if let error = error as? SwiftCloudant.Operation.Error {
                switch error {
                case .http(let httpError):
                    print("http error status code: \(httpError.statusCode)  response: \(httpError.response)")
                    if (httpError.statusCode == 409) {
                        DispatchQueue.main.async {
                            self.alert(title: "Usuario ja existe.", message: "Ja existe um usuario com esse email.")
                        }
                    }
                default:
                    print("Encountered an error while creating a document. Error:\(error)")
                }
            } else {
                print("Created document \(response?["id"]) with revision id \(response?["rev"])")
                DispatchQueue.main.async {
                    if let nav = self.navigationController {
                        nav.popViewController(animated: true)
                    } else {
                        self.dismiss(animated: true, completion: nil)
                    }
                }

            }
        }
        CloudantClient.client.add(operation:create)
    }
    
    func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
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
