//
//  ViewController.swift
//  TareaPeticionServidor
//
//  Created by Cesar Gonzalez on 21/11/16.
//  Copyright © 2016 Cesar Gonzalez. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var ISBNTextField: UITextField!
    @IBOutlet weak var resultTextView: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ISBNTextField.delegate = self
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if(ISBNTextField.text != nil && ISBNTextField.text != ""){
            peticion(isbn: ISBNTextField.text!)
        }
        
        return true
    }
    
    
    func peticion(isbn:String){
        
        let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:\(isbn)"
        let url = URL(string: urls)
        let session = URLSession.shared
        let bloque = {(datos: Data?, resp: URLResponse?, error: Error?) -> Void in
            
            // Make sure we get an OK response
            guard let realResponse = resp as? HTTPURLResponse ,
                realResponse.statusCode == 200 else{
                    print ("Not a 200 response")
                    
                    
                    DispatchQueue.main.async {
                        
                        let myAlert = UIAlertController(title:"Error", message: "\(error!)", preferredStyle: UIAlertControllerStyle.alert)
                        
                        let okAction = UIAlertAction(title:"Ok", style: UIAlertActionStyle.default, handler: nil)
                        myAlert.addAction(okAction)
                        
                        self.present(myAlert, animated:true, completion:nil)                        
                        
                        print(error)
                    }
                    
                    return
            }
            
            
            
            
            if(error != nil){
                
                DispatchQueue.main.async {
                    
                    let myAlert = UIAlertController(title:"Error", message: "\(error!)", preferredStyle: UIAlertControllerStyle.alert)
                    
                    let okAction = UIAlertAction(title:"Ok", style: UIAlertActionStyle.default, handler: nil)
                    myAlert.addAction(okAction)
                    
                    self.present(myAlert, animated:true, completion:nil)
                    
                    
                    print(error)
                }
                
                
            }else{
                let texto = String(data: datos!, encoding: String.Encoding.utf8)
                
                print(texto)
                
                // Hilo principal: dispatch_get_main_queue()
                DispatchQueue.main.async {
                    self.resultTextView.text =  texto
                }
                
            }
            
            
        }
        
        let dt = session.dataTask(with: url!, completionHandler: bloque)
        dt.resume()
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

