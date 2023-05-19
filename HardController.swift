import UIKit
import AVFoundation

class ViewController: UIViewController {

    var listKartu = [
        "A", "B", "C", "D", "E", "F",
        "A", "B", "C", "D", "E", "F",
    ]

    let petaGambar = [
        "A" : "flower",
        "B" : "star",
        "C" : "shroom2",
        "D" : "shroom",
        "E" : "coin",
        "F" : "powerup",
    ]

    var tebakanPertama: Int? = nil
    var audioPlayer: AVAudioPlayer? = nil

    enum soundEffect: String {
        case flip, match, win
    }

    func play(soundFx: soundEffect) {
        let asset = NSDataAsset(name: soundFx.rawValue)!
        let audioData = asset.data

        audioPlayer = try? AVAudioPlayer(data: audioData)
        audioPlayer?.volume = 1.0
        audioPlayer?.play()
    }

    @IBAction func pressButton(_ sender: UIButton) {
        if sender.isSelected { return }
                
                let index = sender.tag
                bukaTutupKartu(kartu: sender)
                
                 
                if let tebakanPertama = self.tebakanPertama {
                    // tebakan kedua
                    let tebakKartu1 = self.listKartu[tebakanPertama - 1]
                    let tebakKartu2 = self.listKartu[index - 1]
                
                    if tebakKartu1 == tebakKartu2 {
                        // cocok
                        play(soundFx: .match)
                        cekMenang()
                    } else {
                        // ga cocok
                        let kartuPertama = self.view.viewWithTag(tebakanPertama) as! UIButton
                        
                        // jeda
                        self.view.isUserInteractionEnabled = false
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3, execute: {
                            [unowned self] in
                            self.bukaTutupKartu(kartu: kartuPertama)
                            self.bukaTutupKartu(kartu: sender)
                            
                            self.view.isUserInteractionEnabled = true
                        })
                    }
                    self.tebakanPertama = nil
                    
                } else {
                    // tebakan pertama
                    self.tebakanPertama = index
                }
    }

    func bukaTutupKartu(kartu: UIButton) {
        let gambar: UIImage
                let transisi: UIView.AnimationTransition
                
                if kartu.isSelected{
                    gambar = UIImage(named: "deck")!
                    transisi = .flipFromLeft
                } else {
                    let isiKartu = listKartu[kartu.tag - 1]
                    let namaGambar = petaGambar[isiKartu]!
                    gambar = UIImage(named: namaGambar)!
                    transisi = .flipFromRight
                }
                 
                UIView.beginAnimations(nil, context: nil)
                UIView.setAnimationTransition(transisi, for: kartu, cache: false)
                kartu.setImage(gambar, for: .normal)
                kartu.isSelected.toggle()
                UIView.commitAnimations()
                play(soundFx: .flip)
    }
    
    // menang
    func cekMenang() {
        let semuaKartu = self.view.subviews
            .filter { view in view.tag > 0 }
            .compactMap { view in view as? UIButton }

        let menang = semuaKartu.allSatisfy { kartu in kartu.isSelected }

        if menang {
            play(soundFx: .win)

            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5.5, execute: { [unowned self] in
                semuaKartu.forEach { kartu in
                    bukaTutupKartu(kartu: kartu)
                }

                // menampilkan pop up ketika sudah menang
                self.showWinPopup()
            })
        }
    }

    // pop up
    func showWinPopup() {
        let alertController = UIAlertController(title: "Congratulations!", message: "You Won The Game!", preferredStyle: .alert)

        let playAgain = UIAlertAction(title: "Play Again", style: .default) { [weak self] (_) in
            // main lagi
            self?.resetGame()
        }

        let backToMenu = UIAlertAction(title: "Back To Menu", style: .default) { (_) in
            // kembali ke menu
            self.dismiss(animated: true, completion: nil)
        }

        alertController.addAction(playAgain)
        alertController.addAction(backToMenu)
        present(alertController, animated: true, completion: nil)
    }

    func resetGame() {
        listKartu.shuffle()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        listKartu.shuffle()
    }
}


