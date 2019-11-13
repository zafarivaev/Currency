import UIKit

class CurrencyTVCell: UITableViewCell {

    //MARK: - Superview Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Properties
    lazy var currencyAbbreviationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 20.0)
        label.textColor = .black
        label.textAlignment = .center
        label.text = "SHORT"
        return label
    }()
    
    lazy var currencyFullLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 20.0)
        label.textColor = .gray
        label.text = "FULL"
        return label
    }()
    
}

//MARK: - UI Setup
extension CurrencyTVCell {
    func setupUI() {
        contentView.addSubview(currencyAbbreviationLabel)
        contentView.addSubview(currencyFullLabel)
        
        currencyAbbreviationLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.width.equalTo(SCREEN_WIDTH * 0.15)
            make.centerY.equalToSuperview()
        }
        
        currencyFullLabel.snp.makeConstraints { (make) in
            make.left.equalTo(currencyAbbreviationLabel.snp.right).offset(20)
            make.centerY.equalToSuperview()
        }
    }
}
