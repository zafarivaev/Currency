import UIKit
import RealmSwift

class RatesViewController: UIViewController {

    //MARK: - Cell Id
    let ratesCellId = "RatesTVCell"
    
    //MARK: - Superview Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadExchangeRates(realm: realm)
        observeExchangeRates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.realm = try! Realm()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    //MARK: - Action
    @objc func addRate() {
        let pickCurrencyVC = PickCurrencyViewController()
        pickCurrencyVC.currencyNumber = .first
        self.navigationController?.pushViewController(pickCurrencyVC, animated: true)
    }
    
    @objc func refresh(sender: AnyObject) {
        loadExchangeRates(realm: realm)
    }

    //MARK: - Properties
    var realm: Realm
    var notificationToken: NotificationToken?
    var exchangeRates: Results<ExchangeRate>?
    
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        //Remove bottom separators
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        return refreshControl
    }()

}

//MARK: - Business Logic
extension RatesViewController {
    func loadExchangeRates(realm: Realm) {
        exchangeRates = realm.objects(ExchangeRate.self)
        self.refreshControl.endRefreshing()
    }
    
    func observeExchangeRates() {
        notificationToken = exchangeRates?.observe({ (changes) in
            let tableView = self.tableView
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                tableView.endUpdates()
            case .error(let error):
                fatalError("\(error)")
            }
        })
    }
    
    func save(exchangeRate: ExchangeRate) {
        do {
            try self.realm.write {
                print("Added exchange rate!")
                self.realm.add(exchangeRate)
            }
        } catch {
            print(error)
        }
    }
    
    func deleteExchangeRate(exchangeRate: ExchangeRate) {
        do {
            try self.realm.write {
                print("Deleted exchange rate!")
                self.realm.delete(exchangeRate)
            }
        } catch {
            print(error)
        }
    }
}

//MARK: - UITableViewDelegate & DataSource
extension RatesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exchangeRates?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ratesCellId) as! RatesTVCell
        if let baseCurrency = self.exchangeRates?[indexPath.row].baseCurrencyAbbreviation {
            cell.fromCurrencyLabel.text = "1 \(baseCurrency)"
            
            if let index = Currencies.data.firstIndex(where: { $0.0 == baseCurrency }) {
                print(Currencies.data[index].1)
                cell.fromCurrencyInfoLabel.text = Currencies.data[index].1
            }
           
        }
        
        if let exchangeCurrencyValue = self.exchangeRates?[indexPath.row].exchangeCurrencyValue.rounded(toPlaces: 2), let exchangeCurrency = self.exchangeRates?[indexPath.row].exchangeCurrencyAbbreviation {
            cell.toCurrencyLabel.text = "\(exchangeCurrencyValue) \(exchangeCurrency)"
            
            if let index = Currencies.data.firstIndex(where: { $0.0 == exchangeCurrency }) {
                print(Currencies.data[index].1)
                cell.toCurrencyInfoLabel.text = Currencies.data[index].1
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            print("Delete a rate")
            if let exchangeRate = exchangeRates?[indexPath.row] {
            deleteExchangeRate(exchangeRate: exchangeRate)
            }
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

//MARK: - UI Setup
extension RatesViewController {
    func setupUI() {
        
        self.view.addSubview(tableView)
        tableView.addSubview(refreshControl)
        
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let ratesCellNib = UINib(nibName: ratesCellId, bundle: nil)
        tableView.register(ratesCellNib, forCellReuseIdentifier: ratesCellId)
    }
    
    func setupNavBar() {
        title = "Rates"
        
        let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addRate))
        self.navigationItem.rightBarButtonItem = addBarButtonItem
    }
}
