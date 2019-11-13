import Foundation
import RealmSwift

class ExchangeRate: Object {
    @objc dynamic var baseCurrencyAbbreviation: String? = ""
    @objc dynamic var exchangeCurrencyValue = 0.0
    @objc dynamic var exchangeCurrencyAbbreviation: String? = ""
    
    convenience init(
        baseCurrencyAbbreviation: String,
        exchangeCurrencyValue: Double,
        exchangeCurrencyAbbreviation: String) {
        self.init()
        self.baseCurrencyAbbreviation = baseCurrencyAbbreviation
        self.exchangeCurrencyValue = exchangeCurrencyValue
        self.exchangeCurrencyAbbreviation = exchangeCurrencyAbbreviation
    }
}
