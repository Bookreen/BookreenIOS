import Foundation
import UIKit
import CoreLocation

final class HomeViewController: AppViewController {
    
    @IBOutlet weak var spaceTypeSegment: UISegmentedControl!
    @IBOutlet weak var constraintHeightOfStatusBar: NSLayoutConstraint!
    @IBOutlet weak var statusBarView: UIView!
    @IBOutlet weak var labelHi: UILabel!
    @IBOutlet weak var labelReservation: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var viewStatusContainer: UIView!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var labelCalendar: UILabel!
    @IBOutlet weak var stackViewCalendar: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imageViewStatus: UIImageView!
    @IBOutlet weak var labelCalendarTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var viewCircle1: UIView!
    @IBOutlet weak var viewCircle2: UIView!
    @IBOutlet weak var viewCircle3: UIView!
    
    var viewModel: HomeViewModelProtocol!
    
    let topConstraintActiveBooking: CGFloat = 260
    let topConstraintNoActiveBooking: CGFloat = 96
    
    var weekDaysView: [CalendarItemView] = []
    private let imageButtonViewIconTintColor = ColorPalette.shared.accentColor
    private let iconBarcode = UIImage(named: "qrsearch")
    private let iconSearch = UIImage(named: "search")
    private let iconNotifications = UIImage(named: "notification")
    private let iconChat = UIImage(named: "iconChat")
    
    private let spacing: CGFloat = 0
    
    private var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        return locationManager
    }()
    
    var currentSpaceType : SpaceType = .desk
    
    var displayBookings=[BookingModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.constraintHeightOfStatusBar.constant = self.getSafeAreaInsetsTop()
        self.statusBarView.backgroundColor = ColorPalette.shared.accentColor
        
        let name = SessionManager.shared.name
        self.labelHi.text = "\(S.hello.localized()) \(name)"
       
        self.labelReservation.text = S.todayReservations.localized()
      
        self.labelCalendar.text = S.weeklyCalendar.localized()
        
        self.viewStatusContainer.backgroundColor = .clear
        self.labelStatus.text = S.youAreAtHomeToday.localized()
        
        self.stackViewCalendar.layer.cornerRadius = 4
        self.stackViewCalendar.layer.borderWidth = 0.8
        self.stackViewCalendar.layer.borderColor = UIColor.systemGray5.cgColor
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat="EEEE, dd MMM"
        self.labelDate.text = dateFormatter.string(from: date)
        
        spaceTypeSegment.setTitle(S.desk.localized(), forSegmentAt: 0)
        spaceTypeSegment.setTitle(S.meeting.localized(), forSegmentAt: 1)
        spaceTypeSegment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.white], for: .selected)
       
        self.configureCircleView(self.viewCircle1)
        self.configureCircleView(self.viewCircle2)
        self.configureCircleView(self.viewCircle3)
        self.configureCollectionView()
    }
    
    private func configureCircleView(_ view: UIView) {
        view.layer.cornerRadius = view.frame.width / 2
        view.backgroundColor = ColorPalette.shared.colorGrey700
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(didChangedLocationHandler(_:)), name: .ChangedLocation, object: nil)
        navigationController?.setNavigationBarHidden(true, animated: true)

        self.viewModel.delegate = self
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.locationManager.delegate = self
        self.updateLabelCalendar()
        self.viewModel.getWeekdays()
        self.requestLocationPermission()
        
        let latitude: Double = UserDefaults.standard.double(forKey: "latitude")
        let longitude: Double = UserDefaults.standard.double(forKey: "longitude")
        self.viewModel.getWeather(latitude: latitude, longitude: longitude)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.viewModel.delegate = nil
        self.locationManager.delegate = nil
        self.collectionView.delegate = nil
        self.collectionView.dataSource = nil
    }
    
    @objc func didChangedLocationHandler(_ notification: Notification) {
        if let data = notification.userInfo as? [String: Double] {
            let latitude = data["latitude"] ?? 0
            let longitude = data["longitude"] ?? 0
            self.viewModel.getWeather(latitude: latitude, longitude: longitude)
        }
    }
    
    private func requestLocationPermission() {
        if #available(iOS 14.0, *) {
            let status = self.locationManager.authorizationStatus
            self.handleStatus(status: status)
        } else {
            let status = CLLocationManager.authorizationStatus()
            self.handleStatus(status: status)
        }
    }
    
    private func handleStatus(status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            NotificationCenter.default.post(name: .ChangedLocationPermission, object: nil)
        } else if status == .denied {
            if !SessionManager.shared.isShowLocationPermission {
                SessionManager.shared.isShowLocationPermission = true
                let alertController = UIAlertController(title: S.locationPermissionTitle.localized(), message: S.pleaseGoSettings.localized(), preferredStyle: .alert)
                let settingsAction = UIAlertAction(title: S.settings.localized(), style: .default) { (_) -> Void in
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
                    }
                }
                let cancelAction = UIAlertAction(title: S.cancel.localized(), style: .default, handler: nil)
                
                alertController.addAction(cancelAction)
                alertController.addAction(settingsAction)
                self.present(alertController, animated: true, completion: nil)
            }
        } else if status == .notDetermined {
            if !SessionManager.shared.isShowLocationPermission {
                SessionManager.shared.isShowLocationPermission = true
                self.locationManager.requestAlwaysAuthorization()
            }
        } else if status == .restricted {
#if DEBUG
            print("restricted: app cannot use location services")
#endif
        }
    }
    
    
    private func configureImageButtonView(
        _ button: ImageButtonView,
        tag: Int,
        icon: UIImage?,
        iconTintColor: UIColor) {
            button.icon = icon
            button.iconTintColor = iconTintColor
            button.tag = tag
        }
    @IBAction func onSegmentChange(_ sender: Any) {
        let index=spaceTypeSegment.selectedSegmentIndex
        toggleEvents(meeting:index==1)
    }
    
  
    
    @IBAction func pressedButtonCalendar(_ sender: UIButton) {
        let userInfo: [String: Int] = ["index": 2]
        NotificationCenter.default.post(name: .didChangeTab, object: nil, userInfo: userInfo)
    }
    
    @IBAction func pressedButtonQrCode(_ sender: UIButton) {
        let viewController = QrViewBuilder.build()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: self.spacing, left: self.spacing, bottom: self.spacing, right: self.spacing)
        layout.minimumLineSpacing = self.spacing
        layout.minimumInteritemSpacing = self.spacing
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = CGSize(width: self.view.frame.width - (self.spacing * 2), height: 10)
        
        self.collectionView.backgroundColor = .clear
        self.collectionView.collectionViewLayout = layout
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: self.spacing, bottom: 0, right: self.spacing)
        self.collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: self.spacing, bottom: 0, right: self.spacing)
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.alwaysBounceVertical = false
        
        let nib = UINib(nibName: BookingCollectionViewCell.nibName, bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: BookingCollectionViewCell.reuseIdentifier)
        
    }
    
    private func showInstantBooking(space: SpaceModel) {
        let viewController = InstantBookingBuilder.makeBottomSheets(space: space) { result in
            switch result {
            case .createReservation(let output):
                self.viewModel.createInstantBooking(space: output.space, time: output.time)
            case .dismiss:
                print("dismiss")
            }
        }
        self.present(viewController, animated: true, completion: nil)
    }
}

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            NotificationCenter.default.post(name: .ChangedLocationPermission, object: nil)
        }
    }
}

extension HomeViewController: HomeViewModelDelegate {
    func handleOutput(_ output: HomeViewOutput) {
        switch output {
        case .showLoading(let isLoading):
            if isLoading {
                NotificationCenter.default.post(name: .showLoadingView, object: nil, userInfo: nil)
            } else {
                NotificationCenter.default.post(name: .dismissLoadingView, object: nil, userInfo: nil)
            }
        case .failureGetLocation:
            print("failureGetLocation")
        case .successSaveInstantBooking(let message):
            self.showSuccessMessage(message)
        case .failureSaveInstantBooking(let message):
            self.showErrorMessage(message)
        case .successGetLocation(let space):
            self.showInstantBooking(space: space)
        case .loadedWeekDayList:
            self.stackViewCalendar.removeAllArrangedSubviews()
            self.weekDaysView.removeAll()
            self.viewModel.weekDayList.forEach { item in
                let calendarItemView = CalendarItemView()
                self.stackViewCalendar.addArrangedSubview(calendarItemView)
                calendarItemView.day = item
                self.weekDaysView.append(calendarItemView)
            }
            self.viewModel.fetchBookingList()
        case .fetchedBookingList:
            self.weekDaysView.forEach { item in
                if let date = item.day?.date {
                    item.hasExistsBooking = self.viewModel.hasExistsBooking(date)
                } else {
                    item.hasExistsBooking = false
                }
            }
            updateDisplayBooking()
        case .failureExtend(let message):
            DialogUtil.showOk(self, message)
        case .successExtend(let message):
            DialogUtil.showOk(self, message)
        }
    }
    
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayBookings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookingCollectionViewCell.reuseIdentifier,
                                                         for: indexPath) as? BookingCollectionViewCell {
            cell.booking = self.displayBookings[indexPath.row]
            cell.delegate = self
            return cell
        }
        return UICollectionViewCell()
    }
}

extension HomeViewController: BookingCollectionViewCellDelegate {
    
    func bookingCollectionViewCell(_ sender: BookingCollectionViewCell, cancelBooking: BookingModel) {
        let viewController = CancelBookingBuilder.makeBottomSheets(booking: cancelBooking) { result in
            switch result {
            case .cancelBooking(let booking):
                self.viewModel.cancelBooking(booking)
            case .dismiss:
                print("dismiss")
            }
        }
        self.present(viewController, animated: true, completion: nil)
    }
    
    func bookingCollectionViewCell(_ sender: BookingCollectionViewCell, extendBooking: BookingModel) {
        let viewController = ExtendBookingBuilder.makeBottomSheets(booking: extendBooking) { result in
            switch result {
            case .extendBooking(let output):
                self.viewModel.extendBooking(output.bookingModel, extendTime: output.extendTime)
            case .dismiss:
                print("dismiss")
            }
        }
        self.present(viewController, animated: true, completion: nil)
    }
    
    func bookingCollectionViewCell(_ sender: BookingCollectionViewCell, startBooking: BookingModel) {
        let viewController = StartBookingBuilder.makeBottomSheets(booking: startBooking) { result in
            switch result {
            case .startBooking(let booking):
                if SessionManager.shared.qrCheckin == "1"{
                    self.showQrView {
                        self.viewModel.startBooking(booking)
                    }
                }else{
                    self.viewModel.startBooking(booking)
                }
            case .dismiss:
                print("dismiss")
            }
        }
        self.present(viewController, animated: true, completion: nil)
    }
    
    private func showQrView(_ done:@escaping (()->Void)){
        let viewController=QrCodeScannerBuilder.make { _ in
            done()
        }
        present(viewController, animated: true, completion: nil)
    }
    
    func bookingCollectionViewCell(_ sender: BookingCollectionViewCell, endBooking: BookingModel) {
        let viewController = EndBookingBuilder.makeBottomSheets(booking: endBooking) { result in
            switch result {
            case .endBooking(let booking):
                if SessionManager.shared.qrCheckin == "1"{
                    self.showQrView {
                        self.viewModel.endBooking(booking)
                    }
                }else{
                    self.viewModel.endBooking(booking)
                }
            case .dismiss:
                print("dismiss")
            }
        }
        self.present(viewController, animated: true, completion: nil)
    }
    func bookingCollectionViewCell(_ sender: BookingCollectionViewCell, editBooking: BookingModel) {
        guard let spaceType=editBooking.spaceTypeId else{
            return
        }
        if spaceType == SpaceType.meeting.rawValue{
            let viewController=MeetingViewBuilder.build(editBooking)
            self.navigationController?.pushViewController(viewController, animated: true)
        }else if spaceType == SpaceType.desk.rawValue{
            let viewController=NewOfficeReservationBuilder.make(editBooking)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
