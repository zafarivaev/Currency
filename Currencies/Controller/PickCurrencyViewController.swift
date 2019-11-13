import UIKit
import PKHUD

class PickCurrencyViewController: UIViewController {
    
    enum CurrencyNumber {
        case first
        case second
    }
    
    //MARK: - Cell Id
    let currencyCellId = "CurrencyTVCell"
    
    //MARK: - Superview Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBarUI()
    }
    
    //MARK: - Properties
    var currencyNumber: CurrencyNumber? = .first
    var currencies = [String]()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        //Remove bottom separators
        tableView.tableFooterView = UIView()
        return tableView
    }()
}

//MARK: - Business Logic
extension PickCurrencyViewController {
    
}

//MARK: - UITableView Delegate & Data Source
extension PickCurrencyViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Currencies.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: currencyCellId) as! CurrencyTVCell
        let currencyAbbreviation = Currencies.data[indexPath.row].0
        let currencyFullName = Currencies.data[indexPath.row].1
        cell.currencyAbbreviationLabel.text = currencyAbbreviation
        cell.currencyFullLabel.text = currencyFullName
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.currencyNumber != .second {
            let pickCurrencyVC = PickCurrencyViewController()
            pickCurrencyVC.currencyNumber = .second
            currencies.append(Currencies.data[indexPath.row].0)
            pickCurrencyVC.currencies = self.currencies
            self.navigationController?.pushViewController(pickCurrencyVC, animated: true)
        } else {
            self.currencies.append(Currencies.data[indexPath.row].0)
            print(self.currencies)
            HUD.show(.progress)
            ExchangeRateService.shared.getExchangeRate(self.currencies[0], self.currencies[1], success: { (code, json) in
                HUD.hide()
                
                let baseCurrency = self.currencies[0]
                let exchangeCurrency = self.currencies[1]
                let exchangeCurrencyValue = json["rates"][self.currencies[1]].double
                let exchangeRate = ExchangeRate(baseCurrencyAbbreviation: baseCurrency, exchangeCurrencyValue: exchangeCurrencyValue!, exchangeCurrencyAbbreviation: exchangeCurrency)
                let ratesVC = self.navigationController?.viewControllers[0] as! RatesViewController
                self.navigationController?.popToViewController(ratesVC, animated: true)
                ratesVC.save(exchangeRate: exchangeRate)
            }) { (code) in
                HUD.hide()
            }
            
        }
    }
    
    
}

//MARK: - UISetup
extension PickCurrencyViewController {
    func setupUI() {
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let ratesCellNib = UINib(nibName: currencyCellId, bundle: nil)
        tableView.register(ratesCellNib, forCellReuseIdentifier: currencyCellId)
    }
    
    func setupNavBarUI() {
        switch currencyNumber {
        case .first:
            title = "First Currency"
        case .second:
            title = "Second Currency"
        case .none:
            break
        }
    }
}
