//
//  LoanViewController.swift
//  Finance Calculator
//
//  Created by user232975 on 7/29/23.
//

import UIKit

class LoanViewController: UIViewController, UITextFieldDelegate {

    var errorLabelsDictionary: [UITextField: UILabel] = [:]

    @IBOutlet weak var presentValueTF: UITextField!
    @IBOutlet weak var futureValueTF: UITextField!
    @IBOutlet weak var interestTF: UITextField!
    @IBOutlet weak var paymentsTF: UITextField!
    @IBOutlet weak var noPaymentsTF: UITextField!
    @IBOutlet weak var compoundPaymentsTF: UITextField!

    @IBOutlet weak var presentValueError: UILabel!
    @IBOutlet weak var futureValueError: UILabel!
    @IBOutlet weak var interestError: UILabel!
    @IBOutlet weak var paymentsError: UILabel!
    @IBOutlet weak var noPaymentsError: UILabel!
    @IBOutlet weak var compoundPaymentsError: UILabel!
    
    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetForm()
        fieldInputEmpty()
        fieldInputNotEmpty()
        
        
        errorLabelsDictionary = [
            presentValueTF: presentValueError,
            futureValueTF: futureValueError,
            interestTF: interestError,
            paymentsTF: paymentsError,
            noPaymentsTF: noPaymentsError,
            compoundPaymentsTF: compoundPaymentsError
        ]
        
    }
    
    func resetForm()
    {
        calculateButton.isEnabled = false
        clearButton.isEnabled = true
        
        presentValueError.isHidden = false
        futureValueError.isHidden = false
        interestError.isHidden = false
        paymentsError.isHidden = false
        noPaymentsError.isHidden = false
        compoundPaymentsError.isHidden = false
        
        clearErrors()
        
        presentValueTF.text = ""
        futureValueTF.text = ""
        interestTF.text = ""
        paymentsTF.text = ""
        noPaymentsTF.text = ""
        compoundPaymentsTF.text = ""
        
        
        presentValueTF.delegate = self
        futureValueTF.delegate = self
        interestTF.delegate = self
        paymentsTF.delegate = self
        noPaymentsTF.delegate = self
        compoundPaymentsTF.delegate = self
        
    }
    
    func clearErrors()
    {
        
        presentValueError.text = ""
        futureValueError.text = ""
        interestError.text = ""
        paymentsError.text = ""
        noPaymentsError.text = ""
        compoundPaymentsError.text = ""
        
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
        if (presentValueTF.text != "" && futureValueTF.text != "" && interestTF.text != "" && paymentsTF.text != "" && noPaymentsTF.text != "" && compoundPaymentsTF.text != "")
        {
            interestError.isHidden = false
            interestError.text = "One Field should be empty for output!"
        }
        else
        {
            clearErrors()
            
            var presentValue: Double = Double(presentValueTF.text ?? "") ?? 0.0
            var futureValue: Double = Double(futureValueTF.text ?? "") ?? 0.0
            var interest: Double = Double(interestTF.text ?? "") ?? 0.0
            var payment: Double = Double(paymentsTF.text ?? "") ?? 0.0
            var noPayments: Double = Double(noPaymentsTF.text ?? "") ?? 0.0
            var compounds: Double = Double(compoundPaymentsTF.text ?? "") ?? 0.0
            
            if presentValueTF.text == ""
            {
                let PV  = getPresentValue(futureValue: futureValue, interest: interest, payment: payment, noPayments: noPayments, compounds: compounds)
                presentValueTF.text = String(format: "%.2f", PV)
            }
            else if futureValueTF.text == ""
            {
                let FV = getFutureValue(presentValue: presentValue, interest: interest, payment: payment, noPayments: noPayments, compounds: compounds)
                futureValueTF.text = String(format: "%.2f", FV)
            }
            else if interestTF.text == ""
            {
                let interestValue = getInterest(presentValue: presentValue, futureValue: futureValue, payment: payment, noPayments: noPayments, compounds: compounds)
                interestTF.text = String(format: "%.2f", interestValue)
            }
            else if paymentsTF.text == ""
            {
                let paymentValue = getPayment(presentValue: presentValue, futureValue: futureValue, interest: interest, noPayments: noPayments, compounds: compounds)
                paymentsTF.text = String(format: "%.2f", paymentValue)
            }
            else if noPaymentsTF.text == ""
            {
                let nPayments = getNoOfPayments(presentValue: presentValue, futureValue: futureValue, interest: interest, payment: payment, compounds: compounds)
                noPaymentsTF.text = String(format: "%.2f", nPayments)
            }
            else if compoundPaymentsTF.text == ""
            {
                let cPayments = getCompoundsPerYear(presentValue: presentValue, futureValue: futureValue, interest: interest, payment: payment, noPayments: noPayments)
                compoundPaymentsTF.text = String(format: "%.2f", cPayments)
            }
            
        }

    }
    
    @IBAction func clearAction(_ sender: Any)
    {
        resetForm()
    }
    
    @IBAction func presentValueChanged(_ sender: Any)
    {
        emptyCheck()
    }
    
    @IBAction func futureValueChanged(_ sender: Any)
    {
        emptyCheck()
    }
    
    @IBAction func interestChanged(_ sender: Any)
    {
        emptyCheck()
    }
    
    @IBAction func paymentsChanged(_ sender: Any)
    {
        emptyCheck()
    }
    
    @IBAction func noPaymentsChanged(_ sender: Any)
    {
        emptyCheck()
    }
    
    @IBAction func compoundPaymentsChanged(_ sender: Any)
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
        
                if count > 1 || count2 > 5
                {
                    calculateButton.isEnabled = false
                }
                else
                {
                    calculateButton.isEnabled = true
                }
        
    }
    
    func getPresentValue(futureValue: Double, interest: Double, payment: Double, noPayments: Double, compounds: Double) -> Double
    {
        let r = interest / (compounds * 100)
        let n = noPayments
        let p = payment
        let FV = futureValue
        
        let PV = FV / pow((1 + r), n)
        return PV
    }
    
    
    func getFutureValue(presentValue: Double, interest: Double, payment: Double, noPayments: Double, compounds: Double) -> Double
    {
        let r = interest / (compounds * 100)
        let n = noPayments
        let p = payment
        let PV = presentValue
        
        let FV = PV * pow((1 + r), n)
        return FV
    }
    
    
    func getInterest(presentValue: Double, futureValue: Double, payment: Double, noPayments: Double, compounds: Double) -> Double
    {
        let FV  = futureValue
        let PV =  presentValue
        let n = noPayments
        let p = payment
        
        let r  = pow((FV / PV), (1 / n)) - 1
        return r * (compounds * 100)
    }
    
    
    func getPayment(presentValue: Double, futureValue: Double, interest: Double, noPayments: Double, compounds: Double) -> Double
    {
        let FV = futureValue
        let PV = presentValue
        let r = interest / (compounds * 100)
        let n = noPayments
        
        let p = (FV - PV * pow((1 + r), n)) / ((pow((1 + r), n)) - 1) * pow((1 + r), n)
        return p
    }
    
    
    func getNoOfPayments(presentValue: Double, futureValue: Double, interest: Double, payment: Double, compounds: Double) -> Double
    {
        let FV = futureValue
        let PV = presentValue
        let r = interest / (compounds * 100)
        let p = payment
        
        let n = log((p / r) / ((p / r) - PV)) / log(1 + r)
        return n
    }
    
    
    func getCompoundsPerYear(presentValue: Double, futureValue: Double, interest: Double, payment: Double, noPayments: Double) -> Double
    {
        let FV = futureValue
        let PV = presentValue
        let r = interest / 100
        let p = payment
        let n = noPayments
        
        let c = pow((FV / PV), (1 / n)) - 1
        return c * 100
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
