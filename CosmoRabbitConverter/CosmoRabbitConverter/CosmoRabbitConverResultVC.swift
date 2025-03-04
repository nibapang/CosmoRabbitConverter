//
//  ConverResultVC.swift
//  CosmoRabbitConverter
//
//  Created by CosmoRabbit Converter on 2025/3/4.
//


import UIKit

class CosmoRabbitConverResultVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var valueLabelName: UILabel!
    @IBOutlet weak var txtInputValue: UITextField!
    @IBOutlet weak var txtResult: UITextField!
    @IBOutlet weak var spaceLabel: UILabel!
    
    
    
    var nameTitle : String?
    var from: String?
    var to: String?
    var valueName: String?
    var unitValue: Double?  // Conversion factor
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spaceLabel.text = nameTitle
        fromLabel.text = from
        toLabel.text = to
        valueLabelName.text = valueName
        
        txtInputValue.delegate = self
        txtInputValue.keyboardType = .decimalPad
        txtResult.isUserInteractionEnabled = false
       
    
        addDoneButtonToKeyboard()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyword))
        view.addGestureRecognizer(tapGesture)
        
        
    }
    
    
    
    @objc func dismissKeyword(){
        txtInputValue.resignFirstResponder()
    }
    
    
    

    private func addDoneButtonToKeyboard() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        
        toolbar.setItems([flexSpace, doneButton], animated: false)
        txtInputValue.inputAccessoryView = toolbar
    }
    
    
    
    
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    
    
    
    
    @IBAction func txtInputChanged(_ sender: UITextField) {
        guard let text = sender.text, !text.isEmpty else {
            txtResult.text = ""
            return
        }
        
        guard let inputValue = Double(text), let unitValue = unitValue else {
            showAlert(message: "Please enter a valid number.")
            return
        }
        
        // Convert the input value
        let result = inputValue * unitValue
        
        // Format the result to only allow 4 characters
        var formattedResult: String
        if result.truncatingRemainder(dividingBy: 1) == 0 {
            formattedResult = String(format: "%.0f", result) // Whole number, no decimal
        } else {
            formattedResult = String(format: "%.4f", result) // Keep 2 decimal places
        }

        
        txtResult.text = formattedResult
    }

 
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // Get the current text, including the new input
        let currentText = textField.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        // Limit input to a maximum of 7 characters
        if updatedText.count > 7 {
            return false
        }
        
        // Allow only numbers and a single decimal point
        if string == "." {
            if textField.text?.contains(".") == true {
                return false // Prevent multiple decimals
            }
        } else if string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil {
            return false // Prevent non-numeric characters
        }
        
        return true
    }
    
   
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Invalid Input", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.txtInputValue.text = "" // Clear the invalid input
        })
        present(alert, animated: true)
    }
    
    @IBAction func btnBackTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    
    
    @IBAction func copyResultButtonTapped(_ sender: Any) {
        guard let resultText = txtResult.text, !resultText.isEmpty else {
            showAlertCopy(message: "No result to copy.")
            return
        }
        
        UIPasteboard.general.string = resultText
        
        showAlertCopy(message: "Result copied to clipboard!")
    }

   
    // MARK: - Show Alert
    private func showAlertCopy(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    
    
}
