//
//  ViewController.swift
//  ScoutCoder
//
//  Created by Andrea Bruno on 07/01/2020.
//  Copyright © 2020 Andrea Bruno. All rights reserved.
//

import UIKit
import GoogleMobileAds
import MaterialComponents.MaterialTextFields
//import MaterialComponents.MaterialTextFields_ColorThemer
import MaterialComponents.MaterialColorScheme
import MaterialComponents.MaterialContainerScheme


class MainViewController: UIViewController {
    let englishAlphabet = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "englishAlphabet", ofType: "plist")!)
    let morseAlphabet = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "morseAlphabet", ofType: "plist")!)
    let italianAlphabet = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "italianAlphabet", ofType: "plist")!)
    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var conversionTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var keyStackView: UIStackView!
    @IBOutlet weak var invertTextStackView: UIStackView!
    @IBOutlet weak var keyResumeLabel: UILabel!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var key1TextField: UITextField!
    @IBOutlet weak var key2TextField: UITextField!
//    @IBOutlet weak var encodedTextField: UITextField!
//    @IBOutlet weak var sourceTextField: UITextField!
    @IBOutlet weak var sourceTextMultilineView: MDCMultilineTextField!
    @IBOutlet weak var encodedTextMultilineView: MDCMultilineTextField!
    
    let toolBar = UIToolbar()
    
    var invertText: Bool = false
    
    var alphaNumericPickerview: UIPickerView = UIPickerView()
    var key1: String = ""
    var key2: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //bannerView.adUnitID = "ca-app-pub-7085815040234496/7313977451"
        bannerView.adUnitID = Bundle.main.object(forInfoDictionaryKey: "GADUnitID") as? String
        //Bundle.main.object(forInfoDictionaryKey: "GADUnitID")
        //bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.delegate = self
        bannerView.load(GADRequest())
        
        doneButton.isEnabled = false
        
        keyResumeLabel.text = String(format:NSLocalizedString("KEY_RESUME_LABEL", comment: ""),key1, key2, NSLocalizedString("NORMAL", comment: ""))
        
        let numberToolbar = UIToolbar(frame:CGRect(origin: .zero, size: .init(width: view.frame.size.width, height: 30)))
        numberToolbar.barStyle = .default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneWithInsertingSourceText))
        numberToolbar.items = [flexSpace,doneButton]
        numberToolbar.sizeToFit()
        
        //sourceTextField.inputAccessoryView = numberToolbar
        
        let tap =  UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
//        let containerScheme = MDCContainerScheme()
//
//        if self.traitCollection.userInterfaceStyle == .dark {
//            let colorScheme = MDCSemanticColorScheme(defaults: .materialDark201907)
//            containerScheme.colorScheme = colorScheme
////            MDCFilledTextFieldColorThemer.applySemanticColorScheme(colorScheme, to: encodedTextMultilineView)
//        } else {
//           let colorScheme = MDCSemanticColorScheme(defaults: .material201907)
//            containerScheme.colorScheme = colorScheme
////            MDCFilledTextFieldColorThemer.applySemanticColorScheme(colorScheme, to: encodedTextMultilineView)
//        }
//        encodedTextMultilineView.
//
//        if #available(iOS 13.0, *) {
//            let colorScheme = MDCSemanticColorScheme()
//            colorScheme.primaryColor = UIColor.systemFill
//            colorScheme.secondaryColor = UIColor.secondarySystemFill
//            colorScheme.backgroundColor = UIColor.systemBackground
//        } else {
//            // Fallback on earlier versions
//        }
        
        encodedTextMultilineView.isEnabled = false
        encodedTextMultilineView.minimumLines = 10
        encodedTextMultilineView.textColor = keyResumeLabel.textColor
        encodedTextMultilineView.placeholderLabel.textColor = UIColor.lightGray
        encodedTextMultilineView.tintColor = keyResumeLabel.tintColor
        encodedTextMultilineView.backgroundColor = keyResumeLabel.backgroundColor
        sourceTextMultilineView.textView?.inputAccessoryView = numberToolbar
        sourceTextMultilineView.textView?.delegate = self
        sourceTextMultilineView.placeholder = "Inserisci qui il testo che desideri codificare"
        sourceTextMultilineView.textColor = keyResumeLabel.textColor
        sourceTextMultilineView.placeholderLabel.textColor = UIColor.lightGray
        sourceTextMultilineView.tintColor = keyResumeLabel.tintColor
        sourceTextMultilineView.backgroundColor = keyResumeLabel.backgroundColor
        sourceTextMultilineView.cursorColor = keyResumeLabel.textColor
        sourceTextMultilineView.minimumLines = 10
        sourceTextMultilineView.expandsOnOverflow = false
        //encodedTextMultilineView.inputAccessoryView = numberToolbar
        dokeyPicker()
        
        key1TextField.inputView = alphaNumericPickerview
        key2TextField.inputView = alphaNumericPickerview
        key1TextField.inputAccessoryView = toolBar
        key2TextField.inputAccessoryView = toolBar
    }
    
    @objc func doneWithInsertingSourceText() {
        self.view.endEditing(true)
    }
    
    @IBAction func conversionTypeChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
//            print("Numerico")
            if !key2.isNumber {
                key2 = "1"
                key2TextField.text = key2
                setKeyResumeLabel()
                dokeyPicker()
            }
            showHideKeyField(isHidden: false)
//            keyStackView.isHidden = false
//            keyStackView.constraints.first {$0.identifier == "keyStackHeightConstraint"}?.constant = 32
//            invertTextStackView.isHidden = false
//            invertTextStackView.constraints.first {$0.identifier == "invertTextStackHeightConstraint"}?.constant = 32
        case 1:
//            print("alfabetico")
            if key2.isNumber {
                key2 = "A"
                key2TextField.text = key2
                setKeyResumeLabel()
                dokeyPicker()
            }
            showHideKeyField(isHidden: false)
//            keyStackView.isHidden = false
//            keyStackView.constraints.first {$0.identifier == "keyStackHeightConstraint"}?.constant = 32
//            invertTextStackView.isHidden = true
//            invertTextStackView.constraints.first {$0.identifier == "invertTextStackHeightConstraint"}?.constant = 32
        case 2:
//            print("Morse")
            showHideKeyField(isHidden: true)
//            keyStackView.isHidden = true
//            keyStackView.constraints.first {$0.identifier == "keyStackHeightConstraint"}?.constant = 0
//            invertTextStackView.isHidden = true
//            invertTextStackView.constraints.first {$0.identifier == "invertTextStackHeightConstraint"}?.constant = 0
        
        default:
            print("\(sender.selectedSegmentIndex)")
        }
        
        setKeyResumeLabel()
    }
    
    func showHideKeyField(isHidden: Bool) {
        UIView.animate(withDuration: 0.6) {
            self.keyStackView.isHidden = isHidden
            self.keyStackView.constraints.first {$0.identifier == "keyStackHeightConstraint"}?.constant = isHidden ? 0 : 32
            /*self.invertTextStackView.isHidden = isHidden
            self.invertTextStackView.constraints.first {$0.identifier == "invertTextStackHeightConstraint"}?.constant = isHidden ? 0 : 32*/
        }
    }
    
    @IBAction func invertTextValueChanged(_ sender: UISwitch) {
        invertText = sender.isOn
        setKeyResumeLabel()
    }
    
    @IBAction func orginalTextDidChange(_ sender: UITextField) {
        if let text = sender.text, !text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty {
            doneButton.isEnabled = true
        } else {
            doneButton.isEnabled = false
        }
    }
    
    func setKeyResumeLabel(){
        let textOrder = invertText ? "INVERTED" : "NORMAL"
        switch conversionTypeSegmentedControl.selectedSegmentIndex {
        case 0:
            keyResumeLabel.text = String(format:NSLocalizedString("KEY_RESUME_LABEL", comment: ""),key1, key2, NSLocalizedString(textOrder, comment: ""))
        case 1:
            keyResumeLabel.text = String(format:NSLocalizedString("KEY_RESUME_LABEL", comment: ""),key1, key2, NSLocalizedString(textOrder, comment: ""))
        case 2:
            keyResumeLabel.text = String(format:NSLocalizedString("MORSE_KEY_RESUME_LABEL", comment: ""), NSLocalizedString(textOrder, comment: ""))
        default:
            print("\(conversionTypeSegmentedControl.selectedSegmentIndex)")
        }
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        var sourceText = sourceTextMultilineView.text ?? ""
        
        if invertText {
            sourceText = String(sourceText.reversed())
        }
        
        sourceText = normalizeText(source: sourceText)
        
        var encodedText = ""
        
        switch conversionTypeSegmentedControl.selectedSegmentIndex {
        case 0:
            encodedText = numericEncoding(sourceText: sourceText)
        case 1:
            encodedText = alphabeticEncoding(sourceText: sourceText)
        case 2:
            encodedText = morseTranslate(sourceText: sourceText)
        default:
            print("Invalid conversion type")
        }
        
        if !encodedText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty{
            shareButton.isEnabled = true
        }
        encodedTextMultilineView.text = encodedText
    }
    
    @IBAction func shareButtonPressed(_ sender: UIBarButtonItem) {
        // text to share
        guard let encodedText = encodedTextMultilineView.text else {return}
        guard let sourceText = sourceTextMultilineView.text else {return}
        guard let keyResume = keyResumeLabel.text else {return}

        // set up activity view controller
        let textToShare = [ keyResume,"", sourceText,"", encodedText ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash

        // exclude some activity types from the list (optional)
//        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]

        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func morseTranslate(sourceText: String) -> String {
        var destText = ""
        for char in sourceText.uppercased() {
            if let morseChar = morseAlphabet?[String(char)] {
                destText = "\(destText)|\(morseChar)"
            } else if char.isPunctuation {
                destText = "\(destText)\(char)|| "
            } else if char.isWhitespace {
                destText = "\(destText)| "
            } else {
                destText = "\(destText)|\(char)"
            }
            
            //print("Found character: \(char)")
        }
        return destText
    }
    
    func alphabeticEncoding(sourceText: String) -> String {
        var destText = ""
        
        guard let alphabet = alphabetForInputString(input: sourceText) else { return "" }
        guard let key1idx = alphabet.allKeys(for: String(key1)).last as? String else { return "" }
        guard let key2idx = alphabet.allKeys(for: String(key2)).last as? String else { return "" }
        
        guard let idx1 = Int(key1idx) else { return "" }
        guard let idx2 = Int(key2idx) else { return "" }
        let idxDiff = (alphabet.count + idx2 - idx1) % alphabet.count
        
        for char in sourceText.uppercased() {
            if let charIdx = alphabet.allKeys(for: String(char)).last as? String, let charNumericIdx = Int(charIdx) {
                let encIdx = (charNumericIdx + idxDiff) % alphabet.count
                destText = "\(destText)\(alphabet["\(encIdx)"] ?? char)"
            } else {
                destText = "\(destText)\(char)"
            }
        }
        return destText
    }
    
    func useEnglishAlphabet(input: String) -> Bool {
        return isEnglish(input: input.lowercased()) || isEnglish(input: key1.lowercased()) || isEnglish(input: key2.lowercased())
    }
    
    func isEnglish(input: String) -> Bool {
        if let integerInput = Int(input) {
            return integerInput > italianAlphabet!.count
        }
        return input.contains("j") || input.contains("k") || input.contains("w") || input.contains("x") || input.contains("y")
    }
    
    func alphabetForInputString(input: String) -> NSDictionary? {
        if useEnglishAlphabet(input: input) {
            return englishAlphabet
        } else {
            return italianAlphabet
        }
    }
    
    func numericEncoding(sourceText: String) -> String {
        var destText = ""
               
        guard let alphabet = alphabetForInputString(input: sourceText) else { return "" }
        guard let key1idx = alphabet.allKeys(for: String(key1)).last as? String else { return "" }
        
        guard let idx1 = Int(key1idx) else { return "" }
        guard let idx2 = Int(key2) else { return "" }
        
        let idxDiff = (alphabet.count + idx2 - idx1) % alphabet.count
        
        for char in sourceText.uppercased() {
            if char.isWhitespace {
                destText = "\(destText) - "
            } else if let charIdx = alphabet.allKeys(for: String(char)).last as? String, let charNumericIdx = Int(charIdx) {
                let encIdx = ((charNumericIdx + idxDiff) % alphabet.count)
                destText = "\(destText)|\(encIdx)"
            } else {
                destText = "\(destText)\(char)"
            }
        }
        
        return destText
    }
    
    func normalizeText(source: String) -> String {
        var source = source.lowercased()
        source = source.replacingOccurrences(of: "[àáâãāăȧäảåǎȁȃạẚấẫẩằắẵǻặ]", with: "a'", options: .regularExpression, range: nil)
        source = source.replacingOccurrences(of: "[èéêẽēĕėẻěếễḕḝⱸ]", with: "e'", options: .regularExpression, range: nil)
        source = source.replacingOccurrences(of: "[ìíîĩĭıïỉǐịįȋḭ]", with: "i'", options: .regularExpression, range: nil)
        source = source.replacingOccurrences(of: "[òóôõōŏȯöőǒȍọồốỗổṍṑờỡởǭǿ]", with: "o'", options: .regularExpression, range: nil)
        source = source.replacingOccurrences(of: "[ùúûūȕưụṷṹǖử]", with: "u'", options: .regularExpression, range: nil)
//        for char in source {
//            print("Found character: \(char)")
//        }
        source = source.decomposedStringWithCompatibilityMapping
        //source = source.decomposedStringWithCanonicalMapping
        let regex = try! NSRegularExpression(pattern: "\\p{Mark}+", options: NSRegularExpression.Options.caseInsensitive)
        let range = NSMakeRange(0, source.count)
        source = regex.stringByReplacingMatches(in: source, options: [], range: range, withTemplate: "'")
//
//        regex = try! NSRegularExpression(pattern: "[àáâãāăȧäảåǎȁȃạẚấẫẩằắẵǻặ]", options: NSRegularExpression.Options.caseInsensitive)
//        range = NSMakeRange(0, source.count)
//        source = regex.stringByReplacingMatches(in: source, options: [], range: range, withTemplate: "'")
//
//        regex = try! NSRegularExpression(pattern: "[èéêẽēĕėẻěếễḕḝⱸ]", options: NSRegularExpression.Options.caseInsensitive)
//        range = NSMakeRange(0, source.count)
//        source = regex.stringByReplacingMatches(in: source, options: [], range: range, withTemplate: "'")
//
//        regex = try! NSRegularExpression(pattern: "[ìíîĩĭıïỉǐịįȋḭ]", options: NSRegularExpression.Options.caseInsensitive)
//        range = NSMakeRange(0, source.count)
//        source = regex.stringByReplacingMatches(in: source, options: [], range: range, withTemplate: "'")
//
//        regex = try! NSRegularExpression(pattern: "[òóôõōŏȯöőǒȍọồốỗổṍṑờỡởǭǿ]", options: NSRegularExpression.Options.caseInsensitive)
//        range = NSMakeRange(0, source.count)
//        source = regex.stringByReplacingMatches(in: source, options: [], range: range, withTemplate: "'")
//
//        regex = try! NSRegularExpression(pattern: "[ùúûūȕưụṷṹǖử]", options: NSRegularExpression.Options.caseInsensitive)
//        range = NSMakeRange(0, source.count)
//        source = regex.stringByReplacingMatches(in: source, options: [], range: range, withTemplate: "'")
//
//        source = source.replacingOccurrences(of: "[òó]", with: "o'", options: .regularExpression, range: nil)
        
        var stringFormatter = StringFormatter()
//        stringFormatter.blacklistCharacters = Set(" -&+$,/:;=?@\"#{}|^~[]`\\*()%.!'")
        stringFormatter.replacementCharacter = "?"
//        stringFormatter.caseRule = .ConvertToLower
        stringFormatter.asciiRule = .AsciiOnly
        
        source = stringFormatter.stringByApplyingFormatting(toString: source)
        return source
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        sourceTextMultilineView.text = ""
        encodedTextMultilineView.text = ""
        shareButton.isEnabled = false
        doneButton.isEnabled = false
    }
}

extension MainViewController: GADBannerViewDelegate {
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
      print("adViewDidReceiveAd")
    }

    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
        didFailToReceiveAdWithError error: GADRequestError) {
      print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
      print("adViewWillPresentScreen")
    }

    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
      print("adViewWillDismissScreen")
    }

    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
      print("adViewDidDismissScreen")
    }

    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
      print("adViewWillLeaveApplication")
    }

}

extension MainViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView == sourceTextMultilineView.textView {
            print("Source Text View")
            if let text = textView.text, !text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty {
                doneButton.isEnabled = true
            } else {
                doneButton.isEnabled = false
            }
        } else if textView == encodedTextMultilineView.textView {
            if let text = textView.text, !text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty {
                shareButton.isEnabled = true
            } else {
                shareButton.isEnabled = false
            }
        }
    }
}

extension MainViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func dokeyPicker() {
        alphaNumericPickerview = UIPickerView(frame:CGRect(x: 0, y: self.view.frame.size.height - 220, width:self.view.frame.size.width, height: 216))
        
        alphaNumericPickerview.dataSource = self
        alphaNumericPickerview.delegate = self
        
        let key1idx = Int((englishAlphabet?.allKeys(for: key1).last as? String ?? "1")) ?? 1
        let key2idx = Int((englishAlphabet?.allKeys(for: key2).last as? String ?? key2)) ?? 1
        alphaNumericPickerview.selectRow(key1idx-1, inComponent: 0, animated: true)
        alphaNumericPickerview.selectRow(key2idx-1, inComponent: 0, animated: true)
        
        key1 = englishAlphabet?["\(key1idx)"] as? String ?? "A"
        if conversionTypeSegmentedControl.selectedSegmentIndex == 1 {
            key2 = englishAlphabet?["\(key2idx)"] as? String ?? "A"
        } else {
            key2 = "\(key2idx)"
        }
        
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        // toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        // toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(MainViewController.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(MainViewController.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true

        self.toolBar.isHidden = false
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 26
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let key:String = "\(row+1)"
        switch component {
        case 0:
            return englishAlphabet?[key] as? String
        case 1:
            if conversionTypeSegmentedControl.selectedSegmentIndex == 1 {
                return englishAlphabet?[key] as? String
            } else {
                return key
            }
        default:
            if conversionTypeSegmentedControl.selectedSegmentIndex == 1 {
                return englishAlphabet?[key] as? String
            } else {
                return key
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let key:String = "\(row+1)"
        switch component {
        case 0:
            key1 = englishAlphabet?[key] as? String ?? ""
            key1TextField.text = key1
            keyResumeLabel.text = String(format:NSLocalizedString("KEY_RESUME_LABEL", comment: ""),key1, key2, NSLocalizedString("NORMAL", comment: ""))
        case 1:
            if conversionTypeSegmentedControl.selectedSegmentIndex == 1 {
                key2 = englishAlphabet?[key] as? String ?? ""
            } else {
                key2 = key
            }
            key2TextField.text = key2
            keyResumeLabel.text = String(format:NSLocalizedString("KEY_RESUME_LABEL", comment: ""),key1, key2, NSLocalizedString("NORMAL", comment: ""))
        default:
            if conversionTypeSegmentedControl.selectedSegmentIndex == 1 {
                key2 = englishAlphabet?[key] as? String ?? ""
            } else {
                key2 = key
            }
            key2TextField.text = key2
            keyResumeLabel.text = String(format:NSLocalizedString("KEY_RESUME_LABEL", comment: ""),key1, key2, NSLocalizedString("NORMAL", comment: ""))
        }
    }
    
    @objc func doneClick() {
//        alphaNumericPickerview.isHidden = true
//        self.toolBar.isHidden = true
        view.endEditing(true)
    }
    
    @objc func cancelClick() {
//        alphaNumericPickerview.isHidden = true
//        self.toolBar.isHidden = true
        view.endEditing(true)
    }
}

struct StringFormatter {
    enum CaseRule {
        case None, UppercaseOnly, ConvertToUpper, LowercaseOnly, ConvertToLower
    }

    enum AsciiRule {
        case None, AsciiOnly
    }

    var blacklistCharacters = Set<Character>()
    var replacementCharacter = ""
    var caseRule = CaseRule.None
    var asciiRule = AsciiRule.None

    func stringByApplyingFormatting(toString string: String) -> String {
        let caseValue = stringWithCaseConversionApplied(string: string)

        let splitCharacters = caseValue.split { !ruleFilter(character: $0) }

        let splitString = splitCharacters.map(String.init)

        let joinedString = splitString.joined(separator: replacementCharacter)

        let finalString = (!ruleFilter(character: caseValue.first ?? Character("")) ? replacementCharacter : "") + joinedString + (!ruleFilter(character: caseValue.last ?? Character("")) ? replacementCharacter : "")

        return finalString
    }

    private func stringWithCaseConversionApplied(string: String) -> String {
        switch caseRule {
        case .ConvertToLower: return string.lowercased()
        case .ConvertToUpper: return string.uppercased()
        default: return string
        }
    }

    private func ruleFilter(character: Character) -> Bool {
        if blacklistCharacters.contains(character) {
            return false
        }

        if asciiRule == .AsciiOnly && !character.isASCII {
            return false
        }

        return caseFilter(character: character)
    }

    private func caseFilter(character: Character) -> Bool {
        if caseRule == .LowercaseOnly && String(character).uppercased() == String(character) {
            return false
        }

        if caseRule == .UppercaseOnly && String(character).lowercased() == String(character) {
            return false
        }

        return true
    }
}

extension String  {
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}
