import UIKit
import Charts

class HistoryVC: UIViewController {
    
    private let week = ["Sun", "Mon", "Tue", "Wed","Thu", "Fri", "Sat"]
    
    private lazy var weekbarChart =  {
        let chart = BarChartView()
        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.chartDescription.enabled = false
        chart.isUserInteractionEnabled = false
        chart.dragEnabled = true
        chart.setScaleEnabled(false)
        chart.pinchZoomEnabled = false
        
        let xAxis = chart.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.drawGridLinesEnabled = false
        xAxis.labelCount = 7
        chart.xAxis.valueFormatter = IndexAxisValueFormatter(values: week)
        chart.animate(yAxisDuration: 3)
        chart.rightAxis.enabled = false
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.minimumFractionDigits = 0
        leftAxisFormatter.maximumFractionDigits = 1
        
        let leftAxis = chart.leftAxis
        leftAxis.labelFont = .systemFont(ofSize: 10)
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
        leftAxis.labelPosition = .outsideChart
        leftAxis.axisMinimum = 0
        leftAxis.axisMaximum = 100
        
        return chart
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(weekbarChart)
        setUpConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        var entries = [BarChartDataEntry]()
        let data = getData()
        for x in 0..<7 {
            entries.append(BarChartDataEntry(x: Double(x), y: data[x]))
        }
        let set = BarChartDataSet(entries: entries, label: "Percentage of total Drink Per Day")
        set.colors = [.cyan]
        let chartData = BarChartData(dataSet: set)
        weekbarChart.data = chartData
    }
    
    private func getData() -> [Double] {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        
        let calender = Calendar.current
        let today = calender.startOfDay(for: Date())
        let dayOfWeek = calender.component(.weekday, from: today)
        let dates = calender.range(of: .weekday, in: .weekOfYear, for: today)!
            .compactMap { calender.date(byAdding: .day, value: $0 - dayOfWeek, to: today) }
        var result = [Double]()
        for date in dates {
            let dateString = formatter.string(from: date)
            let predicate = NSPredicate(format: "date == %@", dateString)
            let dailyAmount = CoreDataManager().retriveData(entity: "AmountRecord", predicate: predicate, keys: [ "totalDrink"])
            let user = CoreDataManager().retriveData(entity: "User", keys: ["weight"])
            if dailyAmount.isEmpty {
                result.append(0)
            } else {
                let amount = dailyAmount[0]["totalDrink"] as! Int
                let total = (user[0]["weight"] as! Int)*30
                result.append((Double(amount)*100)/Double(total))
            }
        }
        return result
    }

    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            weekbarChart.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            weekbarChart.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            weekbarChart.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            weekbarChart.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7)
        ])
    }
}
