import UIKit

class RatesTVCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    lazy var fromCurrencyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 20.0)
        label.textColor = .black
        label.text = "From"
        return label
    }()
    
    lazy var fromCurrencyInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 16.0)
        label.textColor = .gray
        label.text = "From Info"
        return label
    }()
    
    lazy var toCurrencyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 20.0)
        label.textColor = .black
        label.text = "To"
        return label
    }()
    
    lazy var toCurrencyInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 16.0)
        label.textColor = .gray
        label.text = "To Info"
        return label
    }()
    
}

//MARK: - UI Setup
extension RatesTVCell {
    func setupUI() {
        contentView.addSubview(fromCurrencyLabel)
        contentView.addSubview(fromCurrencyInfoLabel)
        contentView.addSubview(toCurrencyLabel)
        contentView.addSubview(toCurrencyInfoLabel)
        
        fromCurrencyLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(10)
        }
        
        fromCurrencyInfoLabel.snp.makeConstraints { (make) in
            make.left.equalTo(fromCurrencyLabel)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        toCurrencyLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-20)
        }
        
        toCurrencyInfoLabel.snp.makeConstraints { (make) in
            make.right.equalTo(toCurrencyLabel)
            make.bottom.equalToSuperview().offset(-10)
        }
        
    }
}
