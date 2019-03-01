//
//  ViewController.swift
//  AlertController
//
//  Created by Praveen Kumar on 25/02/19.
//  Copyright © 2019 Praveen Kumar. All rights reserved.
//

//importing required frameworks and files
import UIKit
import SkyFloatingLabelTextField
import SSBouncyButton
import Toast_Swift
import SCLAlertView
import XLActionController

class ViewController: UIViewController,UITextFieldDelegate {
    
    //Declaring Global variables
    @IBOutlet weak var firstNameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var lastNameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var ageTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var mobileNoTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var showUsersButton: SSBouncyButton!
    @IBOutlet weak var saveButton: SSBouncyButton!
    @IBOutlet weak var countryCodeTextField: SkyFloatingLabelTextField!
    var names = [String:[String:String]]()
    var atTheRateCount:UInt8 = 0
    @IBOutlet weak var resetButton: SSBouncyButton!
    @IBOutlet weak var resetFieldsButton: SSBouncyButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting up the textfields and buttons
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        emailTextField.addTarget(self, action: #selector(emailField(textField:)), for: UIControl.Event.editingChanged)
        countryCodeTextField.delegate = self
        mobileNoTextField.delegate = self
        ageTextField.delegate = self
        saveButton.addTarget(self, action: #selector(onSaveButtonClick), for: UIControl.Event.touchUpInside)
        resetButton.addTarget(self, action: #selector(onResetButtonClick), for: UIControl.Event.touchUpInside)
        showUsersButton.addTarget(self, action: #selector(onShowUsersClick), for: UIControl.Event.touchUpInside)
        resetFieldsButton.addTarget(self, action: #selector(onResetFieldsClick), for: UIControl.Event.touchUpInside)
        
    }
    
    @objc func onResetFieldsClick() {
        firstNameTextField.text!.removeAll()
        lastNameTextField.text!.removeAll()
        emailTextField.text!.removeAll()
        ageTextField.text!.removeAll()
        countryCodeTextField.text!.removeAll()
        mobileNoTextField.text!.removeAll()
    }
    
    @objc func onResetButtonClick() {
        
        if(names.isEmpty) {
            self.view.makeToast("There is no user data to reset", duration: 1.0, position: .center)
        } else {
            
            SweetAlert().showAlert("Are you sure?", subTitle: "This will delete all the saved user data", style: AlertStyle.warning, buttonTitle:"Cancel", buttonColor:UIColorFromRGB(0xD0D0D0) , otherButtonTitle:  "Yes, delete it!", otherButtonColor: UIColorFromRGB(0xDD6B55)) { (isOtherButton) -> Void in
                if isOtherButton == true {
                    
                    SweetAlert().showAlert("Cancelled!", subTitle: "User Data is not deleted", style: AlertStyle.error)
                }
                else {
                    self.names.removeAll()
                    SweetAlert().showAlert("Deleted!", subTitle: "All the user Data has been deleted", style: AlertStyle.success)
                    
                }
            }
        }
        
    }
    
    //method to handle "@" in the emailTextField
    @objc func emailField(textField: UITextField) {
        
        if(textField.text!.contains("@") == false) {
            atTheRateCount = 0
        }
        
    }
    
    //method to restrict whether a method should begin editing or not
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        var editable = false
        
        switch textField {
            
        case firstNameTextField: //for firstNameTextField
            
            editable = true
            
        case lastNameTextField: //for lastNameTextField
            
            if(firstNameTextField.hasText && firstNameTextField.text!.count >= 2) {
                editable = true
            } else {
                self.view.makeToast("Enter First Name", duration: 1.0, position: .top)
                editable = false
            }
            
        case ageTextField:// for ageTextField
            
            if(firstNameTextField.hasText && lastNameTextField.hasText && lastNameTextField.text!.count >= 2) {
                editable = true
            } else {
                self.view.makeToast("Enter Last Name", duration: 1.0, position: .top)
                editable = false
            }
            
        case emailTextField: //for emailTextField
            
            if(firstNameTextField.hasText && lastNameTextField.hasText && lastNameTextField.text!.count >= 2 && ageTextField.hasText && Int(ageTextField.text!)! <= 120) {
                editable = true
            } else {
                self.view.makeToast("Enter Age", duration: 1.0, position: .top)
                editable = false
            }
            
        case countryCodeTextField: //for countryCodeTextField
            
            if(firstNameTextField.hasText && lastNameTextField.hasText && lastNameTextField.text!.count >= 2 && ageTextField.hasText && Int(ageTextField.text!)! <= 120 && emailTextField.hasText) {
                
                let email = emailTextField.text!.lowercased()
                
                if((try! NSRegularExpression(pattern: "[0-9a-z._]+@[a-z0-9]+\\.[a-z]+[a-z]").firstMatch(in: email, options: [], range: NSRange(location: 0, length: email.count))) != nil) { //validating email with regex
                    editable = true
                } else {
                    self.view.makeToast("Check the email format, should be username@domain.com", duration: 2.0, position: .top)
                    editable = false
                }
                
            } else {
                self.view.makeToast("Enter Email", duration: 1.0, position: .top)
            }
            
        case mobileNoTextField: //for mobileNoTextField
            
            if(firstNameTextField.hasText && lastNameTextField.hasText && lastNameTextField.text!.count >= 2 && ageTextField.hasText && Int(ageTextField.text!)! <= 120 && emailTextField.hasText && countryCodeTextField.hasText) {
                editable = true
            } else {
                self.view.makeToast("Enter Country Code", duration: 1.0, position: .top)
                editable = false
            }
            
        default: //default case
            print("default")
        }
        
        return editable
    }
    
    //method to restrict respective text fields as per their requirements
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var age:String = ""
        
        if(ageTextField.hasText) {
            age = ageTextField.text!
        }
        
        var printLetter = false
        
        switch textField {
            
        case firstNameTextField: //for firstNameTextField
            
            if(string.isEmpty) {
                printLetter = true
            } else {
                
                if(string.rangeOfCharacter(from: CharacterSet.letters) != nil) {
                    printLetter = true
                } else {
                    printLetter = false
                    self.view.makeToast("Name can only contain letters", duration: 1.0, position: .center)
                }
                
            }
            
        case lastNameTextField: //for lastNameTextField

            if(string.isEmpty) {
                printLetter = true
            } else {
                
                if(string.rangeOfCharacter(from: CharacterSet.letters) != nil) {
                    printLetter = true
                } else {
                    printLetter = false
                    self.view.makeToast("Name can only contain letters", duration: 1.0, position: .center)
                }
                
            }
            
        case ageTextField: // for ageTextField
            
            if(string.isEmpty) {
                
                printLetter = true
                age.removeLast()
                
            } else if(ageTextField.hasText == false && string == "0") {
                
                printLetter = false
                
                self.view.makeToast("Age cannot start with 0", duration: 1.0, position: .center)
                
            } else {
                
                let numASCII:UInt32 = string.unicodeScalars.first!.value
                
                if(numASCII >= 48 && numASCII <= 57) { //only numbers are accepted
                    
                    age += string
                    
                    let num = Int(age)
                    
                    if(num! <= 120) {
                        printLetter = true
                    } else {
                        printLetter = false
                        self.view.makeToast("Age must be less than 120", duration: 1.0, position: .center)
                    }
                    
                } else {
                    self.view.makeToast("Only numbers 0-9 are allowed", duration: 1.0, position: .center)
                    printLetter = false
                }
                
            }
            
        case emailTextField: //for emailTextField
            
            if(string.isEmpty) {
                
                printLetter = true
                
            }
            
            if(textField.hasText) {
                
                if(string.rangeOfCharacter(from: CharacterSet.alphanumerics) != nil) {
                    
                    printLetter = true
                    
                }
                
                if(string == "." || string == "_") {
                    
                    printLetter = true
                    
                }
                
                if(string == "@") {
                    
                    if(atTheRateCount < 1) {
                        printLetter = true
                        atTheRateCount += 1
                    } else {
                        self.view.makeToast("Email can contain only one @", duration: 1.0, position: .center)
                    }
                    
                }
                
            } else {
                
                if(string.rangeOfCharacter(from: CharacterSet.letters) != nil) {
                    
                    printLetter = true
                    
                } else {
                    self.view.makeToast("Email should start with letters", duration: 1.0, position: .center)
                }
                
            }
            
        case countryCodeTextField: // for countryCodeTextField
            
            if(string.isEmpty) {
                
                printLetter = true
                
            } else {
                
                if(textField.hasText) {
                    
                    if(textField.text!.count >= 4) {
                        printLetter = false
                    } else {
                        
                        if(string.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil) {
                            printLetter = true
                        }
                    }
                } else {
                    if(string == "+") {
                        printLetter = true
                    } else {
                        self.view.makeToast("Country code should start with '+'", duration: 1.0, position: .center)
                    }
                }
            }
            
        case mobileNoTextField: //for mobileNoTextField
            
            if(string.isEmpty) {
                
                printLetter = true
                
            } else if(mobileNoTextField.hasText == false && string == "0") {
                
                printLetter = false
                
                self.view.makeToast("Mobile cannot start with 0", duration: 1.0, position: .center)
                
            } else {
                
                if(textField.text!.count >= 12) {
                    
                    printLetter = false
                    self.view.makeToast("Mobile Number must be only ten digits", duration: 1.0, position: .center)
                    
                } else {
                    
                    if(string.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil) { //only numbers 0-9 are accepted
                        printLetter = true
                    } else {
                        printLetter = false
                        self.view.makeToast("Enter only decimal digits between 0-9", duration: 1.0, position: .center)
                    }
                    
                    if(textField.text!.count == 3) {
                        textField.text! += "-"
                    }
                    
                    if(textField.text!.count == 7) {
                        textField.text! += "-"
                    }
                }
                
                
                
            }
            
        default: // default case
            print("default")
        }
        
        return printLetter
        
    }
    
    
    //Method to handle saving the data on the click of save button
    @objc func onSaveButtonClick() {
        
        if(firstNameTextField.hasText && lastNameTextField.hasText && ageTextField.hasText && emailTextField.hasText && countryCodeTextField.hasText && mobileNoTextField.hasText) { //save data only if all the fields are filled
            
            let alertView = SCLAlertView(appearance: SCLAlertView.SCLAppearance(showCloseButton: false, hideWhenBackgroundViewIsTapped: true)) //creating and alertView for taking a name for the data
            
            let txt = alertView.addTextField("Enter a name")
            txt.adjustsFontSizeToFitWidth = true
            txt.clearButtonMode = UITextField.ViewMode.whileEditing
            txt.keyboardType = UIKeyboardType.asciiCapable
            txt.autocapitalizationType = UITextAutocapitalizationType.words
            txt.autocorrectionType = UITextAutocorrectionType.no
            
            alertView.addButton("Save") { //adding a save button to the alertView
                
                if txt.hasText { // checking to see if given name is already present
                    var alreadyPresent = false
                    
                    for (key,_) in self.names {
                        
                        if key == txt.text! {
                            alreadyPresent = true
                        }
                    }
                    
                    if alreadyPresent == false { //if given name is not already present then save the details
                        var details = [String:String]()
                        details["firstName"] = self.firstNameTextField.text!
                        details["lastName"] = self.lastNameTextField.text!
                        details["age"] = self.ageTextField.text!
                        details["email"] = self.emailTextField.text!
                        details["cc"] = self.countryCodeTextField.text!
                        details["mobileNo"] = self.mobileNoTextField.text!
                        self.names[txt.text!] = details
                        self.firstNameTextField.text = ""
                        self.lastNameTextField.text = ""
                        self.ageTextField.text = ""
                        self.emailTextField.text = ""
                        self.countryCodeTextField.text = ""
                        self.mobileNoTextField.text = ""
                        txt.text = ""
                        self.view.makeToast("Data Saved", duration: 1.0, position: .center)
                    } else {
                        self.view.makeToast("Already Present", duration: 1.0, position: .center)
                    }
                } else {
                    self.view.makeToast("Not Saved, Enter a name", duration: 1.0, position: .center)
                }
                
            }
            
            alertView.showInfo("Enter a name", subTitle: "") //show the alert view
            
        } else {
            self.view.makeToast("Please enter all the fields", duration: 1.0, position: .center)
        }
        
    }
    
    //Method to handle the displaying of users on clikc of show users button
    @objc func onShowUsersClick() {
        
        if(names.isEmpty) { //if userdata is empty then ask user to save details first
            self.view.makeToast("Enter and Save the details first", duration: 1.0, position: .center)
        } else {
            
            let showNamesAlert = SpotifyActionController()//creating and action controller for actionsheet
            
            for (key,value) in names {
                
                let showNamesAction = Action(ActionData(title: key, subtitle: "subtitle"), style: .default, handler: { action in
                    
                    self.view.makeToast("Fetching Data", duration: 1.0, position: .center)
                    
                    self.firstNameTextField.text = value["firstName"]
                    self.lastNameTextField.text = value["lastName"]
                    self.ageTextField.text = value["age"]
                    self.emailTextField.text = value["email"]
                    self.countryCodeTextField.text = value["cc"]
                    self.mobileNoTextField.text = value["mobileNo"]
                })
                
                showNamesAlert.addAction(showNamesAction)
            }
            
            self.present(showNamesAlert, animated: true, completion: nil)
            
            
        }
        
       
    }


}

