import UIKit

class GettingDetailsVC: UIViewController {
    
    //MARK: - Properties
    
    private let pages = Pages().pages
    private var currentIndex = 0,  weight: Int = 0, wakeUp = Date(), dayEnd = Date()
    
    //MARK: - Lazy View Closures
    
    lazy private var titleLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = pages[currentIndex].title
        label.font = .boldSystemFont(ofSize: 30)
        return label
    }()
    
    lazy private var progressView = {
        let progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progress = 0.3
        return progressView
    }()
    
    lazy private var detailLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .systemGray6
        label.text = pages[currentIndex].detail
        label.numberOfLines = 0
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        return label
    }()
    
    lazy private var weightView = {
        let view = UIView()
        view.addSubview(weightPickerView)
        view.addSubview(kgLabel)
        return view
    }()
    
    lazy private var kgLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "kg"
        label.font = .boldSystemFont(ofSize: 40)
        return label
    }()
    
    lazy private var weightPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()
    
    lazy private var timePickerView = {
        let timePickerView = UIView()
        timePickerView.addSubview(timePicker)
        return timePickerView
    }()
    
    lazy private var timePicker = {
        let timePicker = UIDatePicker()
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        timePicker.datePickerMode = .time
        timePicker.preferredDatePickerStyle = .wheels
        return timePicker
    }()
    
    lazy private var previousButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Previous", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.blue.cgColor
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(previousButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy private var nextButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Next", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.blue.cgColor
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy private var horizontalStackView = {
        let stackView = UIStackView(arrangedSubviews: [previousButton, nextButton])
        stackView.axis = .horizontal
        stackView.spacing = 20
        return stackView
    }()
    
    lazy private var verticalStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, progressView, detailLabel, weightView, timePickerView, horizontalStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
    
    //MARK: - Constraints
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: 100),
            
            progressView.heightAnchor.constraint(equalToConstant: 10),
            
            detailLabel.heightAnchor.constraint(equalToConstant: 60),
            
            weightPickerView.centerYAnchor.constraint(equalTo: weightView.centerYAnchor),
            weightPickerView.widthAnchor.constraint(equalToConstant: 120),
            weightPickerView.trailingAnchor.constraint(equalTo: weightView.centerXAnchor),
            
            kgLabel.centerYAnchor.constraint(equalTo: weightPickerView.centerYAnchor),
            kgLabel.leadingAnchor.constraint(equalTo: weightPickerView.trailingAnchor, constant: 20),
            
            timePicker.centerYAnchor.constraint(equalTo: timePickerView.centerYAnchor),
            timePicker.widthAnchor.constraint(equalTo: timePickerView.widthAnchor),
            
            horizontalStackView.heightAnchor.constraint(equalToConstant: 40),
            previousButton.widthAnchor.constraint(equalTo: nextButton.widthAnchor),
            
            verticalStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            verticalStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            verticalStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            verticalStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    //MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(verticalStackView)
        
        setUpConstraints()
        
        weightPickerView.selectRow(51, inComponent: 0, animated: false)
        timePicker.isHidden = true
        previousButton.isHidden = true
    }
    
    @objc func previousButtonPressed() {
        switch currentIndex {
        case 0:
            break
        case 1:
            titleLabel.text = pages[0].title
            detailLabel.text = pages[0].detail
            weightView.isHidden = false
            timePicker.isHidden = true
            progressView.progress = 1/3
            previousButton.isHidden = true
            currentIndex -= 1
        case 2:
            titleLabel.text = pages[1].title
            detailLabel.text = pages[1].detail
            progressView.progress = 2/3
            currentIndex -= 1
        default:
            print("Error")
        }
    }
    
    @objc func nextButtonPressed() {
        switch currentIndex {
        case 0:
            weightView.isHidden = true
            timePicker.isHidden = false
            titleLabel.text = pages[1].title
            detailLabel.text = pages[1].detail
            progressView.progress = 2/3
            previousButton.isHidden = false
            currentIndex += 1
            weight = weightPickerView.selectedRow(inComponent: 0)+1
        case 1:
            titleLabel.text = pages[2].title
            detailLabel.text = pages[2].detail
            progressView.progress = 1.0
            currentIndex += 1
            wakeUp = timePicker.date
        case 2:
            dayEnd = timePicker.date
            saveData()
            let tabBarController = TabBarController()
            tabBarController.modalPresentationStyle = .fullScreen
            present(tabBarController, animated: true, completion: nil)
        default:
            print("Error")
        }
    }
    
    private func saveData() {
        let coreDataManager = CoreDataManager()
        let user = coreDataManager.retriveData(entity: "User", keys: ["weight", "wakeUp", "dayEnd"])
        if user.isEmpty {
            coreDataManager.createData(entity: "User", record: ["weight":weight, "wakeUp":wakeUp, "dayEnd":dayEnd])
        } else {
            coreDataManager.updateData(entity: "User", index: 0, record: ["weight":weight, "wakeUp":wakeUp, "dayEnd":dayEnd])
        }
    }
}

//MARK: - UIPickerViewDataSource

extension GettingDetailsVC: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 400
    }
}

//MARK: - UIPickerViewDelegate

extension GettingDetailsVC: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel
        if let view = view as? UILabel {
            pickerLabel = view
        }
        else {
            pickerLabel = UILabel()
        }
        pickerLabel.text = String(row+1)
        pickerLabel.font = .boldSystemFont(ofSize: 40)
        pickerLabel.textAlignment = .center
        return pickerLabel
    }
}
