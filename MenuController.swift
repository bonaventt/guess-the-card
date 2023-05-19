import UIKit

class MenuController: UIViewController {
    
    @IBAction func exitButton(_ sender: UIButton) {
        exit(0)
    }
    
    @IBOutlet var button: UIButton!
    @IBOutlet var hardButton: UIButton!
    @IBOutlet var easyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.layer.cornerRadius = 10
        easyButton.layer.cornerRadius = 10
        hardButton.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        easyButton.layer.masksToBounds = true
        hardButton.layer.masksToBounds = true
    }
}
