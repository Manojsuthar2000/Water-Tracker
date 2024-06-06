import UIKit

class MainVCTableViewCell: UITableViewCell {
    
    //MARK: - Lazy View Closure
    
    lazy var image = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var timeLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var mlAmount = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()
    
    lazy var deleteButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "trash.slash.circle.fill"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()
    
    lazy var horizontalStackView = {
        let stackView = UIStackView(arrangedSubviews: [image, timeLabel, mlAmount, deleteButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.alignment = .center
        return stackView
    }()
    
    //MARK: - Constraints
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            image.heightAnchor.constraint(equalToConstant: 30),
            image.widthAnchor.constraint(equalToConstant: 30),
            
            timeLabel.heightAnchor.constraint(equalToConstant: 40),
            
            mlAmount.heightAnchor.constraint(equalToConstant: 40),
            mlAmount.widthAnchor.constraint(equalToConstant: 100),
            
            deleteButton.heightAnchor.constraint(equalToConstant: 40),
            deleteButton.widthAnchor.constraint(equalToConstant: 40),
            
            horizontalStackView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            horizontalStackView.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        ])
    }
    
    //MARK: - Methods

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(horizontalStackView)
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
