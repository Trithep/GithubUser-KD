//
//  String+Extensions.swift
//  Core
//

public extension String {
    static let sevenStreamingIdentifierPrefix = "SEVEN_STREAMING_"
    
    func isPhoneNumber() -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^0[0-9]{9}", options: [.caseInsensitive])
            let match = regex.firstMatch(in: self, options: [], range: NSRange(self.startIndex..., in: self))
            return (match != nil)
        } catch {
            return false
        }
    }
    
    func stripHTML() -> String {
        
        if let _ = URL(string: self) {
            return self
        }
        
        let text = self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        if let text = text {
            return text
        } else {
            return self
        }
    }
    
    var coreToNumberFormat: String {
        if let stringInt = Int(self) {
            let formater = NumberFormatter()
            formater.groupingSeparator = ","
            formater.numberStyle = .decimal
            return formater.string(from: NSNumber(value: stringInt)) ?? self
        }
        return self
    }
    
    func encodeURIComponent() -> String? {
        var characterSet = CharacterSet.alphanumerics
        characterSet.insert(charactersIn: "-_.!~*'()")
        return self.addingPercentEncoding(withAllowedCharacters: characterSet)
    }
    
    func getLastComponent() -> String? {
        guard let url = URL(string: self.stripHTML()) else { return nil }
        let last = url.lastPathComponent
        if last.count > 100 {
            let index = last.index(last.endIndex, offsetBy: -100)
            let substring = last[index...]
            return substring.description
        }
        return last
    }
    
}
