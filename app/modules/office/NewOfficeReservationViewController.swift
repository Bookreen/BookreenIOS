import Foundation
import UIKit

final class NewOfficeReservationViewController: AppViewController {

    var viewModel: NewOfficeReservationViewModelProtocol!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var viewDate: UIView!
    @IBOutlet weak var labelAllDay: UILabel!
    @IBOutlet weak var switchAllDay: UISwitch!
    @IBOutlet weak var labelDateTitle: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    
    @IBOutlet weak var restSwitch: UISwitch!
    @IBOutlet weak var restLabel: UILabel!
    @IBOutlet weak var restStackView: UIStackView!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var endTimeView: UIView!
    @IBOutlet weak var hourContentView: UIView!
    @IBOutlet weak var viewHour: UIView!
    @IBOutlet weak var labelMorning: UILabel!
    @IBOutlet weak var labelAfternoon: UILabel!
    @IBOutlet weak var switchMorning: UISwitch!
    @IBOutlet weak var switchAfternoon: UISwitch!
    @IBOutlet weak var labelHourTitle: UILabel!
    
    
    @IBOutlet weak var deskView: UIView!
    @IBOutlet weak var labelDeskTitle: UILabel!
    @IBOutlet weak var labelDesk: UILabel!
    @IBOutlet weak var labelDeskInformation: UILabel!
        
    @IBOutlet weak var labelReminder: UILabel!
    
    @IBOutlet weak var colorPreviewView: UIView!
    @IBOutlet weak var labelColor: UILabel!
    
    @IBOutlet weak var companyServiceOptionsView: UIView!

    private let checkBoxIcon: UIImage? = UIImage(named: "tick")
    
    var serviceOptions=[String:String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title=S.newOfficeReservaton.localized()
        [viewDate,viewHour,deskView,endTimeView].forEach {
            $0?.layer.cornerRadius=10
        }
      
        colorPreviewView.layer.cornerRadius=13
        self.labelAllDay.text = S.allDay.localized()
        self.switchAllDay.isOn = true
        endTimeLabel.text=S.endTime.localized()
        self.labelDateTitle.text = S.date.localized()
        self.labelMorning.text = S.morning.localized()
        self.switchMorning.isOn = false
        self.labelAfternoon.text = S.afternoon.localized()
        self.switchAfternoon.isOn = false
        self.labelHourTitle.text = S.beginTime.localized()
        self.labelDeskTitle.text = S.desk.localized()
        self.labelDesk.text = ""
        self.labelDeskInformation.textColor = ColorPalette.shared.colorRed500
        self.labelDeskInformation.text = S.pleaseSelectDesk.localized()
        self.labelColor.text = S.color.localized()
        self.labelReminder.text = S.reminder.localized()
        restLabel.text=S.restOfDay.localized()
        
        restSwitch.addTarget(self, action: #selector(onRestOfDayChange), for: .valueChanged)

        self.switchAllDay.addTarget(self, action: #selector(onChangeSwitchAllDay), for: .valueChanged)
        self.switchMorning.addTarget(self, action: #selector(onChangeSwitchMorning), for: .valueChanged)
        self.switchAfternoon.addTarget(self, action: #selector(onChangeSwitchAfternoon), for: .valueChanged)
        viewDate.isUserInteractionEnabled=true
        viewDate.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pressedButtonOpenDatePicker)))
        timePicker.addTarget(self, action: #selector(onTimeChange), for: .valueChanged)
        endTimePicker.addTarget(self, action: #selector(onEndTimeChange), for: .valueChanged)
        deskView.isUserInteractionEnabled=true
        deskView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pressedButtonSelectDesk)))
        
        self.viewModel.getAutoSpace()
        self.viewModel.getCompanyServiceOptions()
        addSubmitButton()
        
    }
    
    private func setTimeLimts(){
        guard let date=viewModel.date,let year=Int(date.year),
              let month=Int(date.month),let day=Int(date.day),
              let d=Calendar.current.date(from: DateComponents(year:year,month: month,day: day)) else {return}
        var splites=SessionManager.shared.workStartTime.split(separator: ":")
        if splites.count>1{
            if let hour=Int(String(splites[0])),let minute=Int(String(splites[1])){
                timePicker.minimumDate=Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: d)
                endTimePicker.minimumDate=Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: d)?.addingTimeInterval(30*60)
            }
        }
        splites=SessionManager.shared.workEndTime.split(separator: ":")
        if splites.count>1{
            if let hour=Int(String(splites[0])),let minute=Int(String(splites[1])){
                timePicker.maximumDate=Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: d)?.addingTimeInterval(-30*60)
                endTimePicker.maximumDate=Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: d)
            }
        }
        
    }
    
    private func toggleRestDay(){
        guard let date=viewModel.date,let year=Int(date.year),
              let month=Int(date.month),let day=Int(date.day),
              let d=Calendar.current.date(from: DateComponents(year:year,month: month,day: day)) else {return}
        
        if Calendar.current.isDateInToday(d){
            restStackView.isUserInteractionEnabled = viewModel.timeRangeType == .none
            restStackView.alpha = viewModel.timeRangeType == .none ? 1 : 0.45
        }else{
            restStackView.isUserInteractionEnabled = false
            restStackView.alpha = 0.45
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.delegate = self
        self.parseDate()
        parseHour(false)
        parseHour(true)
        self.parseColor()
        self.parseReminder()
        setTimeLimts()
        self.switchMorning.isOn=viewModel.timeRangeType == .morning
        switchAllDay.isOn = viewModel.timeRangeType == .allDay
        switchAfternoon.isOn = viewModel.timeRangeType == .afternoon
        hourContentView.alpha = viewModel.timeRangeType == .none ? 1 : 0.45
        viewHour.isUserInteractionEnabled = viewModel.timeRangeType == .none
        endTimeView.isUserInteractionEnabled = viewModel.timeRangeType == .none
        toggleRestDay()
       
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.viewModel.delegate = nil
    }
    
    private func addSubmitButton(){
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "round_send_black_24pt"), style: .plain, target: self, action: #selector(pressedButtonCreate))
        button.tintColor = ColorPalette.shared.accentColor
        navigationItem.rightBarButtonItem = button
    }
    
   
    @objc private func pressedButtonCreate() {
        self.viewModel.saveReservation(serviceOptions: serviceOptions)
    }
    
    @objc private func pressedButtonSelectDesk() {
        let selectedSpace = self.viewModel.selectedSpace
        
        guard let _date = self.viewModel.date,let _hour=viewModel.hour,let _end=viewModel.endHour else {
            return
        }

        let planDate = "\(_date.year)-\(_date.month)-\(_date.day)"
        let timeRangeType = self.viewModel.timeRangeType
        var startTime = ""
        var endTime = ""
        
        if timeRangeType == .allDay {
            startTime = SessionManager.shared.workStartTime
            endTime = SessionManager.shared.workEndTime
        } else if timeRangeType == .morning {
            startTime = SessionManager.shared.workStartTime
            endTime = SessionManager.shared.lunchStartTime
        } else if timeRangeType == .afternoon {
            startTime = SessionManager.shared.lunchEndTime
            endTime = SessionManager.shared.workEndTime
        } else {
            startTime = "\(_hour.hour):\(_hour.minute)"
            endTime = "\(_end.hour):\(_end.minute)"
        }
        
        let viewController = SelectSpaceBuilder.make(spaceType:.desk,selectedSpace: selectedSpace, planDate: planDate, startTime: startTime, endTime: endTime) { selectedSpace in
            self.viewModel.selectedSpace = selectedSpace
            self.configureDesk()
        }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc private func pressedButtonOpenDatePicker() {
        let officeDays = self.viewModel.getOfficeDays()
        let datePickerViewController = DatePickerBuilder.makeBottomSheets(officeDays: officeDays, date: self.viewModel.date) { dateFieldModel in
            self.viewModel.date = dateFieldModel
        }
        self.present(datePickerViewController, animated: true, completion: nil)
    }
    
    @objc private func onTimeChange() {
        let c=Calendar.current.dateComponents([.hour,.minute], from: timePicker.date)
        viewModel.hour=HourFieldModel(hour: "\(c.hour!)", minute: "\(c.minute!)")
    }
    
    @objc private func onEndTimeChange(){
        let c=Calendar.current.dateComponents([.hour,.minute], from: endTimePicker.date)
        viewModel.endHour=HourFieldModel(hour: "\(c.hour!)", minute: "\(c.minute!)")
    }
    
    @objc private func onRestOfDayChange(){
        endTimeView.isUserInteractionEnabled = !restSwitch.isOn
        endTimeView.alpha = restSwitch.isOn ? 0.45 : 1.0
        viewHour.isUserInteractionEnabled = !restSwitch.isOn
        viewHour.alpha = restSwitch.isOn ? 0.45 : 1.0
        if restSwitch.isOn{
            let splits=SessionManager.shared.workEndTime.split(separator: ":")
            if splits.count>1{
                let hour="\(splits[0])"
                let minute="\(splits[1])"
                viewModel.endHour=HourFieldModel(hour: hour, minute: minute)
            }
            timePicker.date=Date().addingTimeInterval(180)
            onTimeChange()
        }else{
            onEndTimeChange()
        }
    }
    
    @IBAction func pressedButtonReminder(_ sender: UIButton) {
        let viewController = SelectReminderMinuteBuilder.makeBottomSheets(reminder: self.viewModel.reminderMinutes) { newReminderMinutes in
            self.viewModel.reminderMinutes = newReminderMinutes
        }
        self.present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func pressedButtonSelectColor(_ sender: UIButton) {
        let viewController = SelectColorBuilder.makeBottomSheets { hexColor in
            self.viewModel.selectedColor = hexColor
        }
        self.present(viewController, animated: true, completion: nil)
    }
    
    private func parseDate() {
        if let _date = self.viewModel.date {
            self.labelDate.text = "\(_date.day)/\(_date.month)/\(_date.year)"
        }
        toggleRestDay()
        setTimeLimts()
    }
    
    private func parseHour(_ end:Bool) {
        if let _hour = end ? self.viewModel.endHour : viewModel.hour{
            if let date=self.viewModel.date,let year=Int(date.year),let month=Int(date.month),let day=Int(date.day),let hour=Int(_hour.hour),let minutes=Int(_hour.minute),                let d=Calendar.current.date(from: DateComponents(year: year, month: month, day: day, hour: hour, minute: minutes)){
                (end ? endTimePicker : timePicker)?.date=d
            }
    
        }
    }
    

    
    @objc func onChangeSwitchAllDay() {
        let isOn = self.switchAllDay.isOn
        if isOn {
            self.viewModel.timeRangeType = .allDay
        } else {
            self.viewModel.timeRangeType = .none
        }
    }
    
    @objc func onChangeSwitchMorning() {
        let isOn = self.switchMorning.isOn
        if isOn {
            self.viewModel.timeRangeType = .morning
        } else {
            self.viewModel.timeRangeType = .none
        }
    }
    
    @objc func onChangeSwitchAfternoon() {
        let isOn = self.switchAfternoon.isOn
        if isOn {
            self.viewModel.timeRangeType = .afternoon
        } else {
            self.viewModel.timeRangeType = .none
        }
    }
    
    private func updateTimeViewsState() {
        let isOn = self.switchMorning.isOn || self.switchAfternoon.isOn || self.switchAllDay.isOn
        endTimeView.isUserInteractionEnabled = !isOn
        endTimeView.alpha = isOn ? 0.45 : 1.0
        viewHour.isUserInteractionEnabled = !isOn
        viewHour.alpha = isOn ? 0.45 : 1.0
    }
    
    private func parseTimeView() {
        parseHour(false)
        parseHour(true)
    }
    
    private func parseTimeRangeType() {
        toggleRestDay()
        let timeRangeType = self.viewModel.timeRangeType
        self.switchAllDay.isOn = timeRangeType == .allDay
        self.switchMorning.isOn = timeRangeType == .morning
        self.switchAfternoon.isOn = timeRangeType == .afternoon
        
        let notAllDay = timeRangeType != .allDay
        self.hourContentView.isUserInteractionEnabled = notAllDay
        self.switchMorning.isUserInteractionEnabled = notAllDay
        self.switchAfternoon.isUserInteractionEnabled = notAllDay
        self.hourContentView.alpha = !notAllDay ? 0.45 : 1
        
        updateTimeViewsState()
        
        let workStartTime = SessionManager.shared.workStartTime
        let workEndTime = SessionManager.shared.workEndTime
        let lunchStartTime = SessionManager.shared.lunchStartTime
        let lunchEndTime = SessionManager.shared.lunchEndTime
        let startSplits:[Substring]
        let endSplits:[Substring]
        switch timeRangeType {
        case .morning:
            startSplits=workStartTime.split(separator: ":")
            endSplits=lunchStartTime.split(separator: ":")
        case .afternoon:
            startSplits=lunchEndTime.split(separator: ":")
            endSplits=workEndTime.split(separator: ":")
        default:
            startSplits=workStartTime.split(separator: ":")
            endSplits=workEndTime.split(separator: ":")
        }
        
        let hour = "\(startSplits[0])"
        let minute = "\(startSplits[1])"
        let endH = "\(endSplits[0])"
        let endM = "\(endSplits[1])"
        viewModel.hour = HourFieldModel(hour: hour, minute: minute)
        viewModel.endHour=HourFieldModel(hour: endH, minute: endM)
    }
    
    private func parseReminder() {
        let minute = self.viewModel.reminderMinutes
        let minuteUnit = "minute_unit".localized()
        let reminderFormat = "reminderFormat".localized()
        let boldText = "\(minute) \(minuteUnit)"
        let reminder = reminderFormat
            .replacingOccurrences(of: "[&reminderMinutes&]", with: "\(minute)")
            .replacingOccurrences(of: "[&minuteUnit&]", with: "\(minuteUnit)")
        
        let reminderMutableString = NSMutableAttributedString(
            string: reminder,
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                NSAttributedString.Key.foregroundColor: UIColor.label
            ]
        )
        
        reminderMutableString.setFont(textForAttribute: boldText, withFont: UIFont.boldSystemFont(ofSize: 14))
        self.labelReminder.attributedText = reminderMutableString
    }
    
    private func parseColor() {
        self.colorPreviewView.backgroundColor = self.viewModel.selectedColor.hexStringToUIColor()
    }
    
    private func configureDesk() {
        if let _space = self.viewModel.selectedSpace {
            self.labelDesk.text = _space.spaceName ?? ""
            
            let campusName = _space.campusName ?? ""
            let buildingName = _space.buildingName ?? ""
            let floorName = _space.floorName ?? ""
            self.labelDeskInformation.text = "\(campusName), \(buildingName), \(floorName)"
        }
    }
    
    private func displayCompanyServiceOptions() {
        let companyServiceOptions = self.viewModel.companyServiceOptions
        self.companyServiceOptionsView.subviews.forEach { item in
            if item.tag >= 100 && item.tag < 200 {
                if let switchView = item as? SwitchView {
                    switchView.delegate = nil
                }
                item.removeFromSuperview()
            }
        }
        
        var index = -1
        
        let height = CGFloat(64)
        var lastItem: UIView?
        
        let pairedArray = companyServiceOptions
            .enumerated()
            .map { return ($0.element, companyServiceOptions.count > $0.offset + 1 ? companyServiceOptions[$0.offset + 1] : nil) }
            .enumerated()
            .filter({ $0.offset % 2 == 0 })
            .map { $0.element }
        
        pairedArray.forEach { item in
            serviceOptions[item.0.id ?? ""]="0"
            serviceOptions[item.1?.id ?? ""]="0"
            index = index + 1
            let innerView = UIStackView()
            innerView.distribution = .fillEqually
            innerView.alignment = .fill
            innerView.spacing = 4
            innerView.translatesAutoresizingMaskIntoConstraints = false
            self.companyServiceOptionsView.addSubview(innerView)
            innerView.tag = 100 + index
            innerView.backgroundColor = .clear
            NSLayoutConstraint.activate([
                innerView.leadingAnchor.constraint(equalTo: self.companyServiceOptionsView.leadingAnchor, constant: 0),
                innerView.trailingAnchor.constraint(equalTo: self.companyServiceOptionsView.trailingAnchor, constant: 0),
                innerView.heightAnchor.constraint(equalToConstant: height),
                innerView.topAnchor.constraint(equalTo: self.companyServiceOptionsView.topAnchor, constant: CGFloat(index) * height)
            ])
            
            let leftView = SwitchView()
            leftView.delegate = self
            leftView.metadata = item.0.mapDictionary()
            leftView.text = item.0.name ?? ""
            leftView.id=item.0.id ?? ""
            innerView.addArrangedSubview(leftView)
            
            if let right = item.1 {
                let rightView = SwitchView()
                rightView.delegate = self
                rightView.id=item.1?.id ?? ""
                rightView.metadata = right.mapDictionary()
                rightView.text = right.name ?? ""
                innerView.addArrangedSubview(rightView)
            }
            
            lastItem = innerView
        }
        if let item = lastItem {
            NSLayoutConstraint.activate([
                item.bottomAnchor.constraint(equalTo: self.companyServiceOptionsView.bottomAnchor, constant: 0)
            ])
        }
    }
}

extension NewOfficeReservationViewController: SwitchViewDelegate {
    func onChanged(_ switchView: SwitchView) {
        serviceOptions[switchView.id] = switchView.isOn ? "1" : "0"
    }
}

extension NewOfficeReservationViewController: NewOfficeReservationViewModelDelegate {
    func handleOutput(_ output: NewOfficeReservationViewOutput) {
        DispatchQueue.main.async {
            switch output {
            case .handleError(let error):
                self.handleError(error)
            case .successSaveReservation(let message):
                self.showSuccessMessage(message) {
                    self.navigationController?.popViewController(animated: true)
                }
            case .failureSaveReservation(let message):
                self.showErrorMessage(message)
            case .showLoading(let isLoading):
                if isLoading {
                    NotificationCenter.default.post(name: .showLoadingView, object: nil, userInfo: nil)
                } else {
                    NotificationCenter.default.post(name: .dismissLoadingView, object: nil, userInfo: nil)
                }
            case .onChangeDate:
                self.parseDate()
            case .onChangeHour:
                self.parseHour(false)
            case .onChangeTimeView:
                self.parseTimeView()
            case .onChangeEndHour:
                self.parseHour(true)
            case .onChangeTimeRangeType:
                self.parseTimeRangeType()
            case .onChangeColor:
                self.parseColor()
            case .onChangeReminderMinutes:
                self.parseReminder()
            case .failureGetAutoSpace:
                print("failureGetAutoSpace")
            case .successGetAutoSpace:
                print("successGetAutoSpace")
                self.configureDesk()
            case .loadedCompanyServiceOptions:
                self.displayCompanyServiceOptions()
            }
        }
    }
}


extension NewOfficeReservationViewController: ImageButtonViewDelegate {
    func imageButtonView(pressed: ImageButtonView) {
        self.navigationController?.popViewController(animated: true)
    }
}
