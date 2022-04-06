import Foundation
import UIKit

final class WelcomeViewController: AppViewController, SlideViewControllerDelegate {
    
    @IBOutlet weak var labelWelcome: UILabel!
    @IBOutlet weak var labelLetsGo: UILabel!
    @IBOutlet weak var imageViewBackground: UIImageView!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var viewPage: UIView!
    @IBOutlet weak var indicatorView: CustomIndicatorView!
    @IBOutlet weak var buttonPrev: ImageButtonView!
    @IBOutlet weak var buttonNext: ImageButtonView!
    @IBOutlet weak var buttonSkip: ImageButtonView!
    
    private let iconPrev = UIImage(named: "dismiss")
    private let iconTick = UIImage(named: "tick")
    private let iconNext = UIImage(named: "rightArrow")
    private let iconSkip = UIImage(named: "curvedArrow")
    
    private let viewControllers: [SlideViewController] = [
        WelcomeSelectOfficeBuilder.make(),
        WelcomeUploadProfilePhotoBuilder.make()
    ]
    
    private lazy var pageController: UIPageViewController = {
        let pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageController.view.backgroundColor = .clear
        pageController.view.frame = CGRect(x: 0, y: 0, width: self.viewPage.frame.width, height: self.viewPage.frame.height)
        self.addChild(pageController)
        self.viewPage.addSubview(pageController.view)
        pageController.setViewControllers([viewControllers[0]], direction: .forward, animated: true, completion: nil)
        pageController.didMove(toParent: self)
        return pageController
    }()
    
    var viewModel: WelcomeViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewBackground.backgroundColor = ColorPalette.shared.accentColor
        self.viewBackground.alpha = 0.5
        self.viewContainer.backgroundColor = .systemBackground
        self.viewContainer.layer.cornerRadius = 16
        self.configureWelcomeAndLetsGoLabels()
        self.configureIndicatorView()
        self.configureActionButton(
            self.buttonNext,
            tag: 1,
            image: iconNext,
            imageTintColor: ColorPalette.shared.colorWhite,
            backgroundColor: ColorPalette.shared.accentColor)
        
        self.configureActionButton(
            self.buttonPrev,
            tag: 2,
            image: iconPrev,
            imageTintColor: ColorPalette.shared.colorWhite,
            backgroundColor: ColorPalette.shared.accentColor)
        
        self.configureActionButton(
            self.buttonSkip,
            tag: 3,
            image: iconSkip,
            imageTintColor: ColorPalette.shared.colorWhite,
            backgroundColor: ColorPalette.shared.accentColor)
        self.updateState(index: 0)
    }
    
    private func configureWelcomeAndLetsGoLabels() {
        let welcomeLocalize = "welcome".localized().uppercased()
        self.labelWelcome.text = "\(welcomeLocalize) \(self.viewModel.displayName)"
        self.labelLetsGo.text = "letsGo".localized()
        
        self.labelWelcome.font = .boldSystemFont(ofSize: 22)
        self.labelWelcome.textColor = ColorPalette.shared.colorWhite

        self.labelLetsGo.font = .systemFont(ofSize: 16)
        self.labelLetsGo.textColor = ColorPalette.shared.colorWhite
    }

    override func viewWillAppear(_ animated: Bool) {
        self.pageController.dataSource = self
        self.pageController.delegate = self
        self.viewModel.delegate = self
        self.buttonSkip.delegate = self
        self.buttonPrev.delegate = self
        self.buttonNext.delegate = self
        self.viewControllers.forEach { item in
            item.delegate = self
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.pageController.dataSource = nil
        self.pageController.delegate = nil
        self.viewModel.delegate = nil
        self.buttonSkip.delegate = nil
        self.buttonPrev.delegate = nil
        self.buttonNext.delegate = nil
        self.viewControllers.forEach { item in
            item.delegate = nil
        }
    }

    private func configureIndicatorView() {
        self.indicatorView.activeBackgroundColor = ColorPalette.shared.accentColor
        self.indicatorView.activeBorderColor = ColorPalette.shared.accentColor
        self.indicatorView.defaultBorderColor = ColorPalette.shared.accentColor
        self.indicatorView.defaultBorderWidth = 2
        self.indicatorView.activeBorderWidth = 2
    }
    
    private func configureActionButton(_ button: ImageButtonView,
                                       tag: Int,
                                       image: UIImage?,
                                       imageTintColor: UIColor,
                                       backgroundColor: UIColor) {
        button.icon = image
        button.tag = tag
        button.iconTintColor = imageTintColor
        button.backgroundColor = backgroundColor
    }
    
    private func updateState(index: Int) {
        buttonPrev.isUserInteractionEnabled = index == 1
        buttonPrev.alpha = index == 1 ? 1 : 0
        buttonNext.icon = index == 0 ? iconNext : iconTick
    }
    
    private func goHome() {
        let viewController = CustomTabBuilder.make()
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    func onChangeOffice(campus: CampusModel?, building: BuildingModel?, floor: FloorModel?) {
        self.viewModel.selectedCampus = campus
        self.viewModel.selectedBuilding = building
        self.viewModel.selectedFloor = floor
    }
    
    func onChangeProfilePhoto(image: UIImage) {
        self.viewModel.selectedImage = image
    }
}

extension WelcomeViewController: WelcomeViewModelDelegate {
    func handleOutput(_ output: WelcomeViewOutput) {
        DispatchQueue.main.async {
            switch output {
            case .handleError(let error):
                self.handleError(error)
            case .failureSaveMyOffice:
                print("failureSaveMyOffice")
            case .successSaveMyOffice:
                print("successSaveMyOffice")
            case .successSaveProfilePhoto:
                print("successSaveProfilePhoto")
                self.goHome()
            case .failureSaveProfilePhoto:
                print("failureSaveProfilePhoto")
                self.goHome()
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

extension WelcomeViewController: ImageButtonViewDelegate {
    func imageButtonView(pressed: ImageButtonView) {
        if pressed.tag == self.buttonNext.tag {
            if self.indicatorView.currentIndex == 1 {
                self.viewModel.saveMyOffice()
            } else {
                let index = self.indicatorView.currentIndex + 1
                self.indicatorView.currentIndex = index
                let vc = self.viewControllers[index]
                pageController.setViewControllers([vc], direction: .forward, animated: true, completion: nil)
                self.updateState(index: self.indicatorView.currentIndex)
            }
        } else if pressed.tag == self.buttonSkip.tag {
            self.goHome()
        } else if pressed.tag == self.buttonPrev.tag {
            if self.indicatorView.currentIndex == 1 {
                let index = self.indicatorView.currentIndex - 1
                self.indicatorView.currentIndex = index
                let vc = self.viewControllers[index]
                pageController.setViewControllers([vc], direction: .reverse, animated: true, completion: nil)
                self.updateState(index: self.indicatorView.currentIndex)
            }
        }
    }
}

extension WelcomeViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = viewControllers.firstIndex(of: viewController as! SlideViewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
                
        guard previousIndex >= 0 else {
            return nil
        }
                
        guard viewControllers.count > previousIndex else {
            return nil
        }

        return viewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = viewControllers.firstIndex(of: viewController as! SlideViewController) else {
            return nil
        }

        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = viewControllers.count

        guard orderedViewControllersCount != nextIndex else {
        return nil
        }

        guard orderedViewControllersCount > nextIndex else {
        return nil
        }

        return viewControllers[nextIndex]
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let currentVC = pageViewController.viewControllers?.first else {
            return
        }
        guard let viewControllerIndex = viewControllers.firstIndex(of: currentVC as! SlideViewController) else {
            return
        }
        self.indicatorView.currentIndex = viewControllerIndex
        self.updateState(index: self.indicatorView.currentIndex)
    }
}
