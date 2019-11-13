import Foundation
import SwiftyJSON

class ExchangeRateService: NSObject {
    
    static let shared = { ExchangeRateService() }()
    
    func getExchangeRate(_ firstCurrency: String, _ secondCurrency: String, success: @escaping(Int, JSON) -> (), failure: @escaping (Int) -> ()) {
        
        let SYMBOLS = "symbols=\(firstCurrency),\(secondCurrency)"
        let BASE    = "base=\(firstCurrency)"
        
        APIClient.shared.get(configureApiCall(SYMBOLS, BASE), success: { (code, json) in
            success(code, json)
        }) { (code) in
            failure(code)
        }
        
    }
    
    //Helper
    
    func configureApiCall(_ symbols: String, _ base: String) -> String {
        return "?" + symbols + "&" + base
    }
}
