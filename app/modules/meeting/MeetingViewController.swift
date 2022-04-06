//
//  MeetingViewController.swift
//  Bookreen
//
//  Created by bullhead on 12/2/21.
//

import UIKit
import RxSwift
import Then

class MeetingViewController : UIViewController{
    
   
    @IBOutlet weak var endTimePicker: UIDatePicker!
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var virutalMeetingLabel: UILabel!
    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var participantsLabel: UILabel!
    @IBOutlet weak var endTImeLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var allDayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var rootStackView: UIStackView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var allDaySwitch: UISwitch!
    @IBOutlet weak var reminderLabel: UILabel!
    @IBOutlet weak var reminderStackView: UIStackView!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var colorStack: UIStackView!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var descriptionContainerVIew: UIView!
    @IBOutlet weak var virtualContainerView: UIView!
    @IBOutlet weak var virtualTextField: UITextField!
    @IBOutlet weak var roomTextField: UITextField!
    @IBOutlet weak var roomContainerView: UIView!
    @IBOutlet weak var endTimeContainer: UIView!
    @IBOutlet weak var startTimeContainer: UIView!
    @IBOutlet weak var participantCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewContainer: UIView!
    @IBOutlet weak var dateTextField: UITextView!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var subjectTextField: UITextView!
    @IBOutlet weak var subjectView: UIView!
    
    var participants=[ParticipantModel]()
    var bag=DisposeBag()
    
    var reminderMinutes=15
    var selectedColor="#4CAF50"
    var selectedDate=Date()
    var space:ReservationSpaceModel?
    var allDay=false
    var startTime=Date().addingTimeInterval(60*3)
    var endTime=Calendar.current.date(byAdding: .hour, value: 1, to: Date().addingTimeInterval(60*3))!
    
    var initialValues:(subject:String?,description:String?,link:String?)?
    var id:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingView.isHidden=true
        title=S.meeting.localized()
        [subjectView,dateView,startTimeContainer,endTimeContainer,collectionViewContainer,descriptionContainerVIew,virtualContainerView,roomContainerView].forEach{
            $0?.layer.cornerRadius=10.0
            $0?.layer.masksToBounds=true
        }
        [dateTextField,subjectTextField,descriptionTextField].forEach{
            $0?.textContainer.lineFragmentPadding = 0
        }
        colorView.layer.cornerRadius=15.0
        colorView.backgroundColor=selectedColor.hexStringToUIColor()
        updateTimeLimits()
        addTaps()
        setupBooking()
        addSubmitButton()
        [S.subject:subjectLabel,S.date:dateLabel,S.startTime:startTimeLabel,
         S.endTime:endTImeLabel,S.participants:participantsLabel,
         S.meetingRoom:roomLabel,S.virtualLink:virutalMeetingLabel,
         S.description:descriptionLabel,S.color:colorLabel,
         S.allDay:allDayLabel]
            .forEach {
                $0.value?.text=$0.key.localized()
            }
    }
    
    
    private func addSubmitButton(){
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "round_send_black_24pt"), style: .plain, target: self, action: #selector(editTap))
        button.tintColor = ColorPalette.shared.accentColor
        navigationItem.rightBarButtonItem = button
    }
    
    @objc private func editTap(){
        submit()
    }
    
    private func addTaps(){
        colorStack.isUserInteractionEnabled=true
        colorStack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onColorTap)))
        reminderStackView.isUserInteractionEnabled=true
        reminderStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onReminderTap)))
        dateView.isUserInteractionEnabled=true
        dateView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onDateTap)))
        roomContainerView.isUserInteractionEnabled=true
        roomContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSpaceTap)))
        endTimePicker.addTarget(self, action: #selector(onEndTimeChange), for: .valueChanged)
        startTimePicker.addTarget(self, action: #selector(onStartTimeChange), for: .valueChanged)
    }
    
    
    @objc private func onColorTap(){
        let viewController = SelectColorBuilder.makeBottomSheets { hexColor in
            self.colorView.backgroundColor=hexColor.hexStringToUIColor()
            self.selectedColor=hexColor
        }
        self.present(viewController, animated: true, completion: nil)
    }
    
    @objc private func onReminderTap(){
        let viewController = SelectReminderMinuteBuilder.makeBottomSheets(reminder:reminderMinutes) { newReminderMinutes in
            self.reminderMinutes = newReminderMinutes
            self.updateReminder()
        }
        self.present(viewController, animated: true, completion: nil)
    }

    @IBAction func onAllDayChange(_ sender: Any) {
        allDay=allDaySwitch.isOn
        toggleAllDay()
        getAutoSpace()
    }
    
    @objc private func onDateTap(){
        let c=Calendar.current
        let d=c.dateComponents([.year,.month,.day], from: selectedDate)
        let start=c.dateComponents([.hour,.minute], from: startTime)
        let end=c.dateComponents([.hour,.minute], from: endTime)
        let m=DateFieldModel(day:"\(d.day!)", month: "\(d.month!)", year: "\(d.year!)")
        let datePickerViewController = DatePickerBuilder.makeBottomSheets(officeDays: [0,1,2,3,4,5,6,7], date:m) { date in
            let formatter=DateFormatter()
            formatter.dateFormat="yyyy-MM-dd"
            let date="\(date.year)-\(date.month)-\(date.day)"
            self.selectedDate=formatter.date(from: date)!
            self.updateDate()
            formatter.dateFormat="yyyy-MM-dd HH:mm"
            let s="\(date) \(start.hour!):\(start.minute!)"
            self.startTime=formatter.date(from: s)!
            let e="\(date) \(end.hour!):\(end.minute!)"
            self.endTime=formatter.date(from: e)!
            self.getAutoSpace()
            self.updateTimeLimits()
        }
        self.present(datePickerViewController, animated: true, completion: nil)
    }
    
    
    
    @objc private func onSpaceTap(){
        let date=DateFormatter().then {
            $0.dateFormat="yyyy-MM-dd"
        }.string(from: selectedDate)
        let h=DateFormatter().then {
            $0.dateFormat="HH:mm"
        }
        let start=allDay ? SessionManager.shared.workStartTime : h.string(from: startTime)
        let end=allDay ? SessionManager.shared.workEndTime : h.string(from: endTime)
        let viewController = SelectSpaceBuilder.make(spaceType: .meeting,selectedSpace: space, planDate: date, startTime: start, endTime: end) { selectedSpace in
            self.space = selectedSpace
            self.updateSpace()
        }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}
