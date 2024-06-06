import UIKit

class MyTapGesture: UITapGestureRecognizer {
    var image = String()
    var title = String()
}

class MainVC: UIViewController {
    
    //MARK: - Properties
    
    private var drinkedAmount = 0, totalMl = 0
    private var drinkRecord = [DrinkRecord]()
    private let coreDataManager = CoreDataManager()
    
    //MARK: - Lazy View Closures
    
    lazy private var progressView = {
        let progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    
    lazy private var drinkTargetLabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 30)
        return label
    }()
    
    lazy private var dailyDrinkTargetLabel = {
        let label = UILabel()
        label.text = "Daily Drink Target"
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    lazy private var subTitle = {
        let label = UILabel()
        label.text = "Tap here to record your drunk water"
        return label
    }()
    
    lazy private var horizontalStackView1 = {
        let stackView = UIStackView(arrangedSubviews: [
            getCupButton("cup.and.saucer", "100ml"),
            getCupButton("cup.and.saucer.fill", "125ml"),
            getCupButton("cup.and.saucer", "150ml"),
            getCupButton("wineglass", "175ml")
        ])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        return stackView
    }()
    
    lazy private var horizontalStackView2 = {
        let stackView = UIStackView(arrangedSubviews: [
            getCupButton("wineglass.fill", "200ml"),
            getCupButton("waterbottle", "300ml"),
            getCupButton("waterbottle.fill", "500ml")
        ])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        return stackView
    }()
    
    lazy private var verticalStackView = {
        let stackView = UIStackView(arrangedSubviews: [progressView, drinkTargetLabel, dailyDrinkTargetLabel, horizontalStackView1, horizontalStackView2, subTitle])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 20
        return stackView
    }()
    
    
    lazy private var tableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MainVCTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = 50
        tableView.dataSource = self
        return tableView
    }()
    
    //MARK: - Constraints
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            progressView.heightAnchor.constraint(equalToConstant: 10),
            progressView.widthAnchor.constraint(equalTo: verticalStackView.widthAnchor),
            
            horizontalStackView1.heightAnchor.constraint(equalToConstant: 50),
            horizontalStackView1.widthAnchor.constraint(equalTo: verticalStackView.widthAnchor),
            horizontalStackView2.heightAnchor.constraint(equalToConstant: 50),
            horizontalStackView2.widthAnchor.constraint(equalTo: verticalStackView.widthAnchor),
            
            verticalStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            verticalStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            verticalStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            verticalStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            tableView.topAnchor.constraint(equalTo: verticalStackView.bottomAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            tableView.leadingAnchor.constraint(equalTo: verticalStackView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: verticalStackView.trailingAnchor)
        ])
    }
    
    //MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(verticalStackView)
        view.addSubview(tableView)
        setUpConstraints()
        setLocalNotification()
        setup()
    }
    
    private func setup() {
        let record = coreDataManager.retriveData(entity: "User", index: 0, keys: ["weight"])
        totalMl = (record["weight"] as! Int) * 30
        
        let records = coreDataManager.retriveData(entity: "DailyDrinkRecord", keys: ["image", "mlAmount", "time"])
        for record in records {
            let image = record["image"] as! String
            let amount = record["mlAmount"] as! Int
            drinkedAmount += amount
            let mlAmount = "\(amount) ml"
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm a"
            let time = formatter.string(from: record["time"] as! Date)
            drinkRecord.append(DrinkRecord(image: image, mlAmount: mlAmount, time: time))
        }
        
        drinkTargetLabel.text = "\(drinkedAmount)/\(totalMl)ml"
        progressView.progress = Float(drinkedAmount)/Float(totalMl)
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        let date = formatter.string(from: Date())
        
        let predicate = NSPredicate(format: "date == %@", date)
        let dailyAmount = coreDataManager.retriveData(entity: "AmountRecord", predicate: predicate, keys: [ "totalDrink"])
        if dailyAmount.isEmpty {
            coreDataManager.createData(entity: "AmountRecord", record: ["date": date, "totalDrink": drinkedAmount])
        } else {
            coreDataManager.updateData(entity: "AmountRecord", predicate: predicate, record: ["totalDrink": drinkedAmount])
        }
    }
    
    @objc private func cupButtonTapped(_ sender: MyTapGesture) {
        let mlAmount = Int(sender.title.dropLast(2))!
        
        coreDataManager.createData(entity: "DailyDrinkRecord", record: ["time": Date(), "mlAmount": mlAmount, "image": sender.image])
        
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        let time = formatter.string(from: Date())
        drinkRecord.append(DrinkRecord(image: sender.image, mlAmount: "\(mlAmount) ml", time: time))
        drinkedAmount += mlAmount
        drinkTargetLabel.text = "\(drinkedAmount)/\(totalMl)ml"
        progressView.progress = Float(drinkedAmount)/Float(totalMl)
        tableView.reloadData()
    }
    
    @objc private func deleteButtonTapped(_ sender: UIButton) {
        let record = coreDataManager.retriveData(entity: "DailyDrinkRecord", index: sender.tag, keys: ["mlAmount"])
        drinkedAmount -= record["mlAmount"] as! Int
        
        coreDataManager.deleteData(entity: "DailyDrinkRecord", index: sender.tag)
        
        drinkTargetLabel.text = "\(drinkedAmount)/\(totalMl)ml"
        progressView.progress = Float(drinkedAmount)/Float(totalMl)
        drinkRecord.remove(at: sender.tag)
        tableView.reloadData()
    }
    
    private func getCupButton(_ image: String, _ title: String) -> UIStackView {
        let imageView = UIImageView(image: UIImage(systemName: image))
        imageView.contentMode = .scaleAspectFill
        let label = UILabel()
        label.text = title
        
        let tapGesture = MyTapGesture(target: self, action: #selector(cupButtonTapped(_:)))
        tapGesture.image = image
        tapGesture.title = title
        
        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.backgroundColor = .systemGray6
        stackView.layer.cornerRadius = 5
        stackView.layer.masksToBounds = true
        stackView.addGestureRecognizer(tapGesture)
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 0
        return stackView
    }
    
    private func setLocalNotification() {
        let defaults = UserDefaults.standard
        if let date = defaults.object(forKey: "Date") as? Date,
           let diff = Calendar.current.dateComponents([.hour], from: date, to: Date()).hour, 
            diff < 24 {
            return
        }
        defaults.setValue(Date(), forKey: "Date")
        
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "Water Tracker", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "Never forget to stay hydrated!", arguments: nil)
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "drink-Reminder"
        
        let record = coreDataManager.retriveData(entity: "User", index: 0, keys: ["wakeUp", "dayEnd"])
        let wakeUpTime = record["wakeUp"] as! Date
        let dayEndTime = record["dayEnd"] as! Date
        let currentTime = Date()
        let calendar = Calendar.current
        var start = Calendar.current.date(bySettingHour: calendar.component(.hour, from: wakeUpTime),
                                          minute: calendar.component(.minute, from: wakeUpTime),
                                          second: calendar.component(.second, from: wakeUpTime),
                                          of: currentTime)!
        let end = Calendar.current.date(bySettingHour: calendar.component(.hour, from: dayEndTime),
                                        minute: calendar.component(.minute, from: dayEndTime),
                                        second: calendar.component(.second, from: dayEndTime),
                                        of: currentTime)!
        while start < end {
            let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents(in: .current, from: start), repeats: false)
            let request = UNNotificationRequest.init(identifier: "drink-Reminder", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request)
            start = calendar.date(byAdding: DateComponents(hour: 2), to: start)!
        }
    }
}

//MARK: - UITableViewDataSource

extension MainVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drinkRecord.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MainVCTableViewCell
        cell.image.image = UIImage(systemName: drinkRecord[indexPath.row].image)
        cell.timeLabel.text = drinkRecord[indexPath.row].time
        cell.mlAmount.text = drinkRecord[indexPath.row].mlAmount
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteButtonTapped(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Today's records +"
    }
}
