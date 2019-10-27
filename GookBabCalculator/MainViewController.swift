//
//  ViewController.swift
//  GookBabCalculator
//
//  Created by Minki on 2019/10/22.
//  Copyright © 2019 devming. All rights reserved.
//

import UIKit
import GoogleMobileAds

class MainViewController: UIViewController {
     
    @IBOutlet weak var gookBabTextField: UITextField!
    @IBOutlet weak var productTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var calcButton: UIButton!
    @IBOutlet weak var copyButton: UIButton!
    @IBOutlet weak var mainView: UIView!
    
    let adCount = 5
    
    var gookBabPrice: Int {
        get {
            return Int(gookBabTextField.text ?? "8000") ?? 8000
        }
    }
    var productPrice: Int {
        get {
            return Int(productTextField.text ?? "0") ?? 0
        }
    }
    
    var calcCountForAd: Int {
        get {
            return UserDefaults.standard.integer(forKey: "calcCount")
        }
        set {
            var setValue = newValue
            if newValue >= 6 {
                setValue = 0
            }
            UserDefaults.standard.set(setValue, forKey: "calcCount")
        }
    }
    
    var bannerView: GADBannerView!
    var resultPrice = 0
    

    var interstitial: GADInterstitial!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.productTextField.delegate = self
        
        // In this case, we instantiate the banner with desired ad size.
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        
        addBannerViewToView(bannerView)
//        if let infoDic: [String: Any] = Bundle.main.infoDictionary, let bottomKey = infoDic["adUnitID"] as? String {
        bannerView.adUnitID = "ca-app-pub-1393207989866736/8356448079"//"ca-app-pub-3940256099942544/2934735716" //bottomKey
//            bannerView.adUnitID = bottomKey
//        }
        
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self

        interstitial = GADInterstitial(adUnitID: "ca-app-pub-1393207989866736/5640948537")

        let request = GADRequest()
        interstitial.load(request)
        
        setupUI()
    }
    
    func setupUI() {
        calcButton.layer.cornerRadius = 4.0
        calcButton.layer.borderColor = UIColor.black.cgColor
        calcButton.layer.borderWidth = 1.0
        
        copyButton.layer.cornerRadius = 4.0
        copyButton.layer.borderColor = UIColor.black.cgColor
        copyButton.layer.borderWidth = 1.0
        
        mainView.layer.cornerRadius = 4.0
        mainView.layer.shadowColor = UIColor.black.cgColor
        mainView.layer.shadowOffset = CGSize(width: 1, height: 4)
        mainView.layer.shadowRadius = 8
        mainView.layer.shadowOpacity = 0.3
        
//        let shadowPath = UIBezierPath(roundedRect: mainView.bounds, cornerRadius: 4.0)
//        mainView.layer.shadowPath = shadowPath.cgPath
    }
    
    @IBAction func calc(_ sender: Any) {
        print("calcCountForAd: \(calcCountForAd)")
        if calcCountForAd == adCount {
            if interstitial.isReady {
              interstitial.present(fromRootViewController: self)
            } else {
              print("Ad wasn't ready")
            }
        }
        
        if let gookBabPrice = Int(gookBabTextField.text ?? "0"),
            let productPrice = Int(productTextField.text ?? "0") {
            if gookBabPrice <= 0 {
                resultLabel.text = "뭐?? 뜨끈한 국밥이 얼마라고??"
                return
            }
            resultPrice = productPrice / gookBabPrice
        }
        gookBabTextField.resignFirstResponder()
        productTextField.resignFirstResponder()
        
        switch productPrice {
        case SpecialPrice.heattech.rawValue:
            resultLabel.text = "유니클로 히트텍 살려고?? ㅉㅉ 그거 살 바엔 뜨끈한 국밥 한그릇 든든하게 먹고 애국하지"
            return
        default:
            break
        }
        
        if resultPrice == 0 {
            resultLabel.text = "그 돈으로는 뜨~끈한 국밥 한 그릇도 못사묵겠구만 ㅠㅠ"
        } else {
            resultLabel.text = "그거 살 바엔 뜨~끈한 국밥 \(resultPrice)그릇 든든하게 묵고 말지"
        }
        calcCountForAd += 1
    }
    
    func showConfirmationAlert(alertTitle title: String, alertMessage message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        //dialog: ca-app-pub-1393207989866736/8960202868
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func copyWord(_ sender: Any) {
        gookBabTextField.resignFirstResponder()
        productTextField.resignFirstResponder()
        
        let copyText =
        """
        [\(productPrice)원이라고?!]
        - 국밥가격: \(gookBabPrice)원
        - 물건가격: \(productPrice)원
        * 결론: \(resultLabel.text ?? "") *
        - 국밥계산기 다운로드 -> https://apps.apple.com/kr/app/%EA%B5%AD%EB%B0%A5%EA%B3%84%EC%82%B0%EA%B8%B0/id1484660593
        """
        //        let copyText = "\(resultLabel.text ?? "")"
        let activityVC = UIActivityViewController(activityItems: [copyText], applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
        
        
        //        UIPasteboard.general.string =
        //        showConfirmationAlert(alertTitle: "복사되었습니다.", alertMessage: resultLabel.text)
    }
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .bottom,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
        ])
    }
}

extension MainViewController: GADBannerViewDelegate {
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("adViewWillPresentScreen")
    }
    
    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("adViewWillDismissScreen")
    }
    
    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
    }
}

extension MainViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == productTextField {
            if range.location == 1 && productTextField.text == "0" {
                productTextField.text = ""
            } else if range.location == 0 && string.isEmpty {
                productTextField.text = "0"
            }
        }
        return true
    }
}
