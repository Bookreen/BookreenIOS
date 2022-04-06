import Foundation
import UIKit
import Lottie

fileprivate let animationViewTag: Int = 997
fileprivate let backgroundViewTag: Int = 998
fileprivate let overlayViewTag: Int = 999
fileprivate let radiusViewTag: Int = 1000

extension UIView {
    func displayAnimatedActivityIndicatorView() {
        setActivityIndicatorView()
    }
    func hideAnimatedActivityIndicatorView() {
        removeActivityIndicatorView()
    }
}


extension UIViewController {
    private var overlayContainerView: UIView {
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            return window
        }
        else if let navigationView: UIView = navigationController?.view {
            return navigationView
        }
        return view
    }
    
    func displayAnimatedActivityIndicatorView() {
        overlayContainerView.displayAnimatedActivityIndicatorView()
    }
    
    func hideAnimatedActivityIndicatorView() {
        overlayContainerView.hideAnimatedActivityIndicatorView()
    }
}

// Private interface
extension UIView {
    private var lottieAnimationView: AnimationView {
        let view: AnimationView = AnimationView(animation: Animation.named("loading"))
        view.tag = animationViewTag
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    private var radiusView: RadiusView {
        let view: RadiusView = RadiusView(frame: CGRect(x: 0, y: 0, width: 96, height: 96))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tag = radiusViewTag
        view.backgroundColor = .secondarySystemBackground
        view.cornerRadius = 16
        view.isEnableTopLeftCornerRadius = true
        view.isEnableTopRightCornerRadius = true
        view.isEnableBottomRightCornerRadius = true
        view.isEnableBottomLeftCornerRadius = true
        return view
    }
        
    private var overlayView: UIView {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.alpha = 0.5
        view.tag = overlayViewTag
        return view
    }
    
    private var backgroundView: UIView {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.tag = backgroundViewTag
        return view
    }
        
    private func setActivityIndicatorView() {
        guard !isDisplayingLoadingOverlay() else { return }
        let backgroundView: UIView = self.backgroundView
        let overlayView: UIView = self.overlayView
        let radiusView: RadiusView = self.radiusView
        let lottieAnimationView: AnimationView = self.lottieAnimationView
        lottieAnimationView.contentMode = .scaleAspectFill
        lottieAnimationView.loopMode = .loop
        //add subviews
        backgroundView.addSubview(overlayView)
        backgroundView.addSubview(radiusView)
        radiusView.addSubview(lottieAnimationView)
        
        UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.addSubview(backgroundView)
        //add overlay constraints
        backgroundView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        backgroundView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        overlayView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        overlayView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    
        //add indicator constraints
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: radiusView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 96),
            NSLayoutConstraint(item: radiusView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 96)
        ])
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: lottieAnimationView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 72),
            NSLayoutConstraint(item: lottieAnimationView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 72)
        ])
        lottieAnimationView.centerXAnchor.constraint(equalTo: radiusView.centerXAnchor).isActive = true
        lottieAnimationView.centerYAnchor.constraint(equalTo: radiusView.centerYAnchor).isActive = true
        
        radiusView.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor).isActive = true
        radiusView.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor).isActive = true
        lottieAnimationView.play()
    }
        
    private func removeActivityIndicatorView() {
        guard let backgroundView: UIView = getBackgroundView(),
              let overlayView: UIView = getOverlayView(),
              let radiusView: RadiusView = getRadiusView(),
              let animationView: AnimationView = getAnimationView() else { return }
            
        UIView.animate(withDuration: 0.2, animations: {
            overlayView.alpha = 0.0
            animationView.stop()
        }) { _ in
            animationView.removeFromSuperview()
            radiusView.removeFromSuperview()
            overlayView.removeFromSuperview()
            backgroundView.removeFromSuperview()
        }
    }
        
    private func isDisplayingLoadingOverlay() -> Bool {
        return (getBackgroundView() != nil) &&
            (getOverlayView() != nil) &&
            (getRadiusView() != nil) &&
            (getAnimationView() != nil)
    }

    private func getRadiusView() -> RadiusView? {
        viewWithTag(radiusViewTag) as? RadiusView
    }

    private func getOverlayView() -> UIView? {
        viewWithTag(overlayViewTag)
    }
    
    private func getBackgroundView() -> UIView? {
        viewWithTag(backgroundViewTag)
    }
    
    private func getAnimationView() -> AnimationView? {
        viewWithTag(animationViewTag) as? AnimationView
    }
}
