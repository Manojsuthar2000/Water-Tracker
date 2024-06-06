import UIKit

class TabBarController: UITabBarController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.viewControllers = [home, history, settings]
    }
    
    lazy private var home: MainVC = {
        
        let home = MainVC()
        
        let title = "Home"
        
        let defaultImage = UIImage(systemName: "house")
        
        let selectedImage = UIImage(named: "house.fill")
        
        let tabBarItems = (title: title, image: defaultImage, selectedImage: selectedImage)
        
        let tabBarItem = UITabBarItem(title: tabBarItems.title, image: tabBarItems.image, selectedImage: tabBarItems.selectedImage)
        
        home.tabBarItem = tabBarItem
        
        return home
    }()
    
    lazy private var history: HistoryVC = {
        
        let history = HistoryVC()
        
        let defaultImage = UIImage(systemName: "arrow.counterclockwise.circle")
        
        let selectedImage = UIImage(systemName: "arrow.counterclockwise.circle.fill")
        
        let tabBarItem = UITabBarItem(title: "History", image: defaultImage, selectedImage: selectedImage)
        
        history.tabBarItem = tabBarItem
        
        return history
    }()
    
    lazy private var settings: UIViewController = {
        
        let settings = UIViewController()
        
        let defaultImage = UIImage(systemName: "gearshape")
        
        let selectedImage = UIImage(systemName: "gearshape.fill")
        
        let tabBarItem = UITabBarItem(title: "Settings", image: defaultImage, selectedImage: selectedImage)
        
        settings.tabBarItem = tabBarItem
        
        return settings
    }()
}
