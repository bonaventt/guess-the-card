import UIKit

class SplashController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
            self.performSegue(withIdentifier: "openMenu", sender: nil)
            }
    }
}
