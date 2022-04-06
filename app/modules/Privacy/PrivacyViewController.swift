import Foundation
import UIKit


final class PrivacyViewController: UIViewController {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription1: UILabel!
    @IBOutlet weak var labelDescription2: UILabel!
    @IBOutlet weak var labelReadAndAcceptPrivacyPolicy: UILabel!
    @IBOutlet weak var labelSwitchReadAndAcceptPrivacyPolicy: UILabel!
    @IBOutlet weak var switchPrivacyPolicy: UISwitch!
    @IBOutlet weak var buttonSubmit: UIButton!
    
    var viewModel: PrivacyViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.switchPrivacyPolicy.isOn = false
        self.labelTitle.text = "privacy_title".localized()
        self.labelDescription1.text = "privacy_description_1".localized()
        self.labelDescription2.text = "privacy_description_2".localized()
        self.labelReadAndAcceptPrivacyPolicy.text = "read_and_accept_privacy_policy".localized()
        self.labelSwitchReadAndAcceptPrivacyPolicy.text = "i_read_and_accept_privacy_policy".localized()
        self.configureButtonSubmit()
        
        self.switchPrivacyPolicy.tintColor = ColorPalette.shared.colorGrey300
        self.switchPrivacyPolicy.addTarget(self, action: #selector(onChangeAcceptPrivacyPolicyStatus), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.delegate = self
        self.onChangeAcceptPrivacyPolicyStatus()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.viewModel.delegate = nil
    }
    
    @objc func onChangeAcceptPrivacyPolicyStatus() {
        let isOn = self.switchPrivacyPolicy.isOn
        self.buttonSubmit.isUserInteractionEnabled = isOn
        self.buttonSubmit.alpha = isOn ? 1.0 : 0.5
    }
    
    private func configureButtonSubmit() {
        self.buttonSubmit.layer.cornerRadius = 8
        self.buttonSubmit.backgroundColor = ColorPalette.shared.accentColor
        self.buttonSubmit.setTitleColor(.white, for: .normal)
        self.buttonSubmit.setTitle("ok".localized(), for: .normal)
    }
    
    @IBAction func  pressedButtonOpenBrowser(_ sender: UIButton) {
        let viewController = AppBrowserBuilder.make(screenTitle: "privacy_policy".localized(), urlAsString: "privacy_policy_url".localized())
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func  pressedButtonSubmit(_ sender: UIButton) {
        self.viewModel.acceptPrivacyPolicy()
    }
    
    private func goToHome() {
        let viewController = CustomTabBuilder.make()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    private func goToWelcome() {
        let viewController = WelcomeBuilder.make()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension PrivacyViewController: PrivacyViewModelDelegate {
    func handleOutput(_ output: PrivacyViewOutput) {
        DispatchQueue.main.async {
            switch output {
            case .navigateWelcome:
                self.goToWelcome()
            case .navigateHome:
                self.goToHome()
            case .showLoading(let isLoading):
                if isLoading {
                    NotificationCenter.default.post(name: .showLoadingView, object: nil, userInfo: nil)
                } else {
                    NotificationCenter.default.post(name: .dismissLoadingView, object: nil, userInfo: nil)
                }
            }
        }
    }
}
