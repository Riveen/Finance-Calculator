//
//  MortgageViewController.swift
//  Finance Calculator
//
//  Created by user232975 on 7/29/23.
//

import UIKit

class MortgageViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var amountTF: UITextField!
    @IBOutlet weak var interestTF: UITextField!
    @IBOutlet weak var paymentTF: UITextField!
    @IBOutlet weak var yearsTF: UITextField!
    @IBOutlet weak var amountError: UILabel!
    @IBOutlet weak var interestError: UILabel!
    @IBOutlet weak var paymentError: UILabel!
    @IBOutlet weak var yearsError: UILabel!
    
    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    var errorLabelsDictionary: [UITextField: UILabel] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetForm()
        fieldInputEmpty()
        fieldInputNotEmpty()
        
        
        errorLabelsDictionary = [
            amountTF: amountError,
            interestTF: interestError,
            paymentTF: paymentError,
            yearsTF: yearsError
        ]
    }
    
    func resetForm()
    {
        amountError.isEnabled = true
        interestTF.isEnabled = true
        paymentError.isEnabled = true
        yearsError.isEnabled = true
        calculateButton.isEnabled = false
        clearButton.isEnabled = true
        
        amountError.isHidden = false;
        interestError.isHidden = false;
        paymentError.isHidden = false;
        yearsError.isHidden = false;
        
        clearErrors()
        
        amountTF.text = ""
        interestTF.text = ""
        paymentTF.text = ""
        yearsTF.text = ""
        
        amountTF.delegate = self
        interestTF.delegate = self
        paymentTF.delegate = self
        yearsTF.delegate = self
    }
    
    func clearErrors()
    {
        amountError.text = ""
        interestError.text = ""
        paymentError.text = ""
        yearsError.text = ""
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let validCharacterSet = CharacterSet(charactersIn: "0123456789.").union(CharacterSet(charactersIn: ""))
        
        if let range = string.rangeOfCharacter(from: validCharacterSet.inverted)
        {
            return false
        }
        
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        let dotCount = newText.components(separatedBy: ".").count - 1
        if dotCount > 1
        {
            return false
        }
        
        if string == "." && newText.isEmpty
        {
            return true
        }
        
        if string == "0" && newText.count == 1 && newText != "0"
        {
            return true
        }
        
        if let errorLabel = errorLabelsDictionary[textField]
        {
            var message = "";
            if let dotRange = newText.range(of: ".")
            {
                let digitsAfterDecimal = newText.suffix(from: dotRange.upperBound)
                if digitsAfterDecimal.count > 2
                {
                    errorLabel.text = "Max. 2 digits after decimal!"
                    return false
                }
                else
                {
                    errorLabel.text = ""
                }
                
            }
        }

        
        return true
    }
    
    
    @IBAction func amountChanged(_ sender: Any)
    {
        emptyCheck()
        
    }
    
    @IBAction func interestChanged(_ sender: Any)
    {
        emptyCheck()
    }
    
    @IBAction func paymentChanged(_ sender: Any)
    {
    
        emptyCheck()
    }
    
    @IBAction func yearsChanged(_ sender: Any)
    {
        
        emptyCheck()
    }
    
    @IBAction func calculateAction(_ sender: Any)
    {
        var interestRate: Double
        var payment: Double
        var amount: Double
        var years: Double
        
        if (amountTF.text != "" && interestTF.text != "" && paymentTF.text != "" && yearsTF.text != "")
        {
            interestError.isHidden = false
            interestError.text = "One Field should be empty for output!"
        }
        else
        {
            clearErrors()
            
            if amountTF.text == ""
            {
                interestRate = Double(interestTF.text ?? "") ?? 0.0
                payment = Double(paymentTF.text ?? "") ?? 0.0
                years = Double(yearsTF.text ?? "") ?? 0.0
                
                let loanAmount = getAmount(interest: interestRate, payment: payment, years: years)
                amountTF.text = String(format: "%.2f", loanAmount)
            }
            else if interestTF.text == ""
            {
                amount = Double(amountTF.text ?? "") ?? 0.0
                payment = Double(paymentTF.text ?? "") ?? 0.0
                years = Double(interestTF.text ?? "") ?? 0.0
                
                let interestRate = getInterest(amount: amount, payment: payment, years: years)
                interestTF.text = String(format: "%.2f%",interestRate)
            }
            else if paymentTF.text == ""
            {
                interestRate = Double(interestTF.text ?? "") ?? 0.0
                amount = Double(amountTF.text ?? "") ?? 0.0
                years = Double(yearsTF.text ?? "") ?? 0.0
                let monthlyPayment = getPayment(interest: interestRate, amount: amount, years: years)
                paymentTF.text = String(format: "%.2f", monthlyPayment)
            }
            else if yearsTF.text == ""
            {
                interestRate = Double(interestTF.text ?? "") ?? 0.0
                amount = Double(amountTF.text ?? "") ?? 0.0
                payment = Double(paymentTF.text ?? "") ?? 0.0
                let loanYears = getYears(amount: amount, interest: interestRate, payment: payment)
                yearsTF.text = String(format: "%.2f", loanYears)
            }
           
        }
        
        
    }
    
    
    @IBAction func clearAction(_ sender: Any)
    {
        resetForm()
    }
    
    func fieldInputEmpty() -> Int
    {
        var count = 0
        for case let textField as UITextField in self.view.subviews {
            if textField.text == ""
            {
                count+=1
            }
        }
        return count;
    }
    
    func fieldInputNotEmpty() -> Int
    {
        var count = 0
        for case let textField as UITextField in self.view.subviews{
            if textField.text != ""
            {
                count += 1
            }
        }
        return count
    }
    
    func emptyCheck()
    {
                let count = fieldInputEmpty()
                let count2 = fieldInputNotEmpty()
                
                if count > 1 || count2 > 3
                {
                    calculateButton.isEnabled = false
                }
                else
                {
                    calculateButton.isEnabled = true
                }
        
    }
    
    func getAmount(interest: Double, payment: Double, years: Double) -> Double
    {
        let r = interest / (12 * 100)
        let n = years * 12
        let loanAmount = payment * (1 - pow(1+r, -n)) / r
        return loanAmount
    }
    
    func getPayment(interest: Double, amount: Double, years: Double) -> Double
    {
        let monthlyPayment = amount * (interest / (12 * 100)) * pow(1 + interest / (12 * 100), years * 12)
        return monthlyPayment
    }
    
    func getInterest(amount: Double, payment: Double, years: Double) -> Double
    {
        var interestRate = 0.05
        
            let r = interestRate / (12 * 100)
            let n = years * 12
            let updatedInterestRate = interestRate - (amount * r * pow(1+r, n)) / (pow(1+r, n) - 1) - payment
            
            interestRate = updatedInterestRate

        return interestRate
    }
    
    func getYears(amount: Double, interest: Double, payment: Double) -> Double
    {
        var loanYears = 30
        
            let r  = interest / (12 * 100)
            let n = (loanYears * 12)
            let paymentCalValue = (payment * (pow(1 + r,Double(n)) - 1))
            let amountCalValue = (amount*r*pow(1+r, Double(n)))
            let updatedLoanMonths = Double(n) -  (paymentCalValue / amountCalValue)
            let updatedLoanYears = updatedLoanMonths / 12
            loanYears = Int(updatedLoanYears)
        
            return Double(loanYears)
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
