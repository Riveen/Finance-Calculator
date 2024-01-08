//
//  SavingsViewController.swift
//  Finance Calculator
//
//  Created by user232975 on 7/29/23.
//

import UIKit

class SavingsViewController: UIViewController, UITextFieldDelegate {
    
    var errorLabelsDictionary: [UITextField: UILabel] = [:]

    @IBOutlet weak var amountTF: UITextField!
    @IBOutlet weak var interestTF: UITextField!
    @IBOutlet weak var paymentTF: UITextField!
    @IBOutlet weak var compoundsTF: UITextField!
    @IBOutlet weak var yearPaymentsTF: UITextField!
    @IBOutlet weak var futureValueTF: UITextField!
    @IBOutlet weak var totalPaymentsTF: UITextField!
    
    @IBOutlet weak var amountError: UILabel!
    @IBOutlet weak var interestError: UILabel!
    @IBOutlet weak var paymentError: UILabel!
    @IBOutlet weak var compoundsError: UILabel!
    @IBOutlet weak var yearPaymentsError: UILabel!
    @IBOutlet weak var futureValueError: UILabel!
    @IBOutlet weak var totalPaymentsError: UILabel!
    
    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetForm()
        fieldInputEmpty()
        fieldInputNotEmpty()
        
        
        errorLabelsDictionary = [
            amountTF: amountError,
            interestTF: interestError,
            paymentTF: paymentError,
            compoundsTF: compoundsError,
            yearPaymentsTF: yearPaymentsError,
            futureValueTF: futureValueError,
            totalPaymentsTF: totalPaymentsError
        ]
    }
    
    func resetForm()
    {
        calculateButton.isEnabled = false
        clearButton.isEnabled = true
        
        amountError.isHidden = false;
        interestError.isHidden = false;
        paymentError.isHidden = false;
        compoundsError.isHidden = false;
        yearPaymentsError.isHidden = false;
        futureValueError.isHidden = false;
        totalPaymentsError.isHidden = false;
        
        clearErrors()

        amountTF.text = ""
        interestTF.text = ""
        paymentTF.text = ""
        compoundsTF.text = ""
        yearPaymentsTF.text = ""
        futureValueTF.text = ""
        totalPaymentsTF.text = ""
        
        
        amountTF.delegate = self
        interestTF.delegate = self
        paymentTF.delegate = self
        compoundsTF.delegate = self
        yearPaymentsTF.delegate = self
        futureValueTF.delegate = self
        totalPaymentsTF.delegate = self
        
    }
    
    func clearErrors()
    {
        
        amountError.text = ""
        interestError.text = ""
        paymentError.text = ""
        compoundsError.text = ""
        yearPaymentsError.text = ""
        futureValueError.text = ""
        totalPaymentsError.text = ""
        
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
    
    @IBAction func calculateAction(_ sender: Any)
    {
        
        if (amountTF.text != "" && interestTF.text != "" && paymentTF.text != "" && compoundsTF.text != "" && yearPaymentsTF.text != "" && futureValueTF.text != "" && totalPaymentsTF.text != "")
        {
            interestError.isHidden = false
            interestError.text = "One Field should be empty for output!"
        }
        else
        {
            clearErrors()
            
            var amount: Double = Double(amountTF.text ?? "") ?? 0.0
            var interest: Double = Double(interestTF.text ?? "") ?? 0.0
            var payment: Double = Double(paymentTF.text ?? "") ?? 0.0
            var compounds: Double = Double(compoundsTF.text ?? "") ?? 0.0
            var yearPayments: Double = Double(yearPaymentsTF.text ?? "") ?? 0.0
            var futureValue: Double = Double(futureValueTF.text ?? "") ?? 0.0
            var totalPayments: Double = Double(totalPaymentsTF.text ?? "") ?? 0.0
            
            if amountTF.text == ""
            {
                let principleAmount = getPrincipleAmount(interest: interest, compounds: compounds, yearPayments: yearPayments, futureValue: futureValue, totalPayments: totalPayments, payment: payment)
                amountTF.text = String(format: "%.2f", principleAmount)
            }
            else if interestTF.text == ""
            {
                let interestPer = getInterest(amount: amount, compounds: compounds, yearPayments: yearPayments, futureValue: futureValue, totalPayments: totalPayments, payment: payment)
                interestTF.text = String(format: "%.2f", interestPer)
            }
            else if paymentTF.text == ""
            {
                let pay = getPayment(interest: interest, compounds: compounds, yearPayments: yearPayments, futureValue: futureValue, totalPayments: totalPayments, amount: amount)
                paymentTF.text = String(format: "%.2f", pay)
            }
            else if compoundsTF.text == ""
            {
                let c = getCompounds(amount: amount, interest: interest, yearPayments: yearPayments, futureValue: futureValue, totalPayments: totalPayments, payment: payment)
                compoundsTF.text = String(format: "%.2f", c)
            }
            else if yearPaymentsTF.text == ""
            {
                let yPayments = getPaymentsPerYear(compounds: compounds, totalPayments: totalPayments)
                yearPaymentsTF.text = String(format: "%.2f", yPayments)
            }
            else if futureValueTF.text == ""
            {
                let fv = getFutureValue(amount: amount, interest: interest, yearPayments: yearPayments, compounds: compounds, totalPayments: totalPayments, payment: payment)
                futureValueTF.text = String(format: "%.2f", fv)
            }
            else if totalPaymentsTF.text == ""
            {
                let tPayments = getTotalPayments(amount: amount, interest: interest, yearPayments: yearPayments, compounds: compounds, futureValue: futureValue, payment: payment)
                totalPaymentsTF.text = String(format: "%.2f", tPayments)
            }
            
        }
    }
    
    @IBAction func clearAction(_ sender: Any)
    {
        resetForm()
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
    
    @IBAction func compoundChanged(_ sender: Any)
    {
            emptyCheck()
    }
    
    @IBAction func yearPaymentsChanged(_ sender: Any)
    {
            emptyCheck()
    }
    
    @IBAction func futureValueChanged(_ sender: Any)
    {
            emptyCheck()
    }
    
    @IBAction func totalPaymentsChanged(_ sender: Any)
    {
            emptyCheck()
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
        
                
                if count > 1 || count2 > 6
                {
                    calculateButton.isEnabled = false
                }
                else
                {
                    calculateButton.isEnabled = true
                }
        
    }
    
    
    func getPrincipleAmount(interest: Double, compounds: Double, yearPayments: Double, futureValue: Double, totalPayments: Double, payment: Double) -> Double
    {
        let r = interest / 100.0
        
        let numerator = pow(1+r/(compounds), (compounds * totalPayments))
        let principleAmount = futureValue / numerator
        
        return principleAmount
    }
    
    
    func getInterest(amount: Double, compounds: Double, yearPayments: Double, futureValue: Double, totalPayments: Double, payment: Double) -> Double
    {
        
        let numerator1 = pow((futureValue / amount), (1 / (compounds * totalPayments)))
        let numerator2 = (numerator1 - 1) * compounds
        let r = numerator2 * 100
        
        return r
    }
    
    
    func getPayment(interest: Double, compounds: Double, yearPayments: Double, futureValue: Double, totalPayments: Double, amount: Double) -> Double
    {
        let r = interest / 100.0
        
        let numerator = pow((1 + r/compounds), (compounds * totalPayments))
        let payment = futureValue / ((numerator - 1) / (r / compounds))
        
        return payment
    }
    
    
    func getCompounds(amount: Double, interest: Double, yearPayments: Double, futureValue: Double, totalPayments: Double, payment: Double) -> Double
    {
        let r = interest / 100.0
        
        let numerator1 = futureValue / amount
        let numerator2 = log(numerator1) / (totalPayments * log(1 + r))
        let n = ceil(numerator2)
        
        return n
    }
    
    func getPaymentsPerYear(compounds: Double, totalPayments: Double) -> Double
    {
        let paymentsYear = compounds * totalPayments
        return paymentsYear
    }
    
    func getFutureValue(amount: Double, interest: Double, yearPayments: Double, compounds: Double, totalPayments: Double, payment: Double) -> Double
    {
        let r = interest / 100.0
        
        let numerator1 = pow((1 + r/compounds), (compounds * totalPayments))
        let numerator2 = payment * (numerator1 - 1) / (r / compounds)
        let futureValue = (amount * numerator1) + numerator2
        
        return futureValue
    }
    
    
    func getTotalPayments(amount: Double, interest: Double, yearPayments: Double, compounds: Double, futureValue: Double, payment: Double) -> Double
    {
        let r = interest / 100.0
        
        let numerator1 = (futureValue * (r / compounds)) / (payment * (r / compounds) + (futureValue - amount))
        let numerator2 = log(numerator1)
        let totalPayments = numerator2 / log(1 + (r / compounds))
        
        return totalPayments
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
