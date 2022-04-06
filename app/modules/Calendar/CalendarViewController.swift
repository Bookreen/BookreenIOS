import Foundation
import UIKit
import FSCalendar

final class CalendarViewController: AppViewController {
    
    @IBOutlet weak var topConstraintOfHeaderView: NSLayoutConstraint!
    @IBOutlet weak var viewNavigationBar: UIView!
    @IBOutlet weak var labelScreenTitle: UILabel!
    
    
    @IBOutlet weak var todayButton: UIButton!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    
    private var spaceType = SpaceType.desk
    private var displayableBooking=[BookingModel]()
    
    var viewModel: CalendarViewModelProtocol!
    
    private let formatter=DateFormatter().then {
        $0.dateFormat="yyyy-MM-dd"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.topConstraintOfHeaderView.constant = self.getSafeAreaInsetsTop()
        self.viewNavigationBar.backgroundColor = ColorPalette.shared.accentColor
        self.labelScreenTitle.text = S.myCalendar.localized()
        self.labelScreenTitle.textColor = ColorPalette.shared.colorWhite
        self.labelScreenTitle.font = .systemFont(ofSize: 16)
        self.segmentControl.setTitle(S.office.localized(), forSegmentAt: 0)
        self.segmentControl.setTitle(S.meeting.localized(), forSegmentAt: 1)
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.white], for: .selected)
        self.configureTableView()
        self.configureCalendarView()
        todayButton.setTitle(S.today.localized(), for: .normal)
        segmentControl.addTarget(self, action: #selector(onSpaceTypeTap), for: .valueChanged)
    }
    
    
    private func configureCalendarView() {
        self.calendarView.today = nil
        self.goToToday()
    }
    
    private func configureTableView() {
        self.tableView.tableFooterView = UIView()
        self.tableView.allowsSelection = true
        self.tableView.separatorStyle = .none
        self.tableView.register(ReservationHeader.self,
                                forHeaderFooterViewReuseIdentifier: "ReservationHeader")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.delegate = self
        self.calendarView.delegate = self
        self.calendarView.dataSource = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.viewModel.fetchBookingList()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.viewModel.delegate = nil
        self.calendarView.delegate = nil
        self.calendarView.dataSource = nil
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
    }
    
    
    @IBAction func pressedButtonToday(_ sender: UIButton) {
        self.goToToday()
    }
    
    @objc private func onSpaceTypeTap() {
        spaceType = segmentControl.selectedSegmentIndex == 0 ? .desk : .meeting
        tableView.reloadData()
        calendarView.reloadData()
    }
    
    private func goToToday() {
        let date = Date()
        self.calendarView.select(date)
        self.viewModel.selectedDate = date
        self.viewModel.changeMonth(spaceType:spaceType,date)
        self.viewModel.selectBookingListByDate(spaceType:spaceType,date)
    }
    
    func diffFromToday(_ date: Date) -> Int {
        let diffs = Calendar.current.dateComponents([.day], from: Date(), to: date)
        return diffs.day ?? -1
    }
}

extension CalendarViewController: CalendarViewModelDelegate {
    func handleOutput(_ output: CalendarViewOutput) {
        switch output {
        case .showLoading(let isLoading):
            print(isLoading)
        case .fetchedBookingList:
            self.calendarView.reloadData()
            self.tableView.reloadData()
        case .updatedBookingList(let indexPath):
            self.tableView.reloadData()
            DispatchQueue.main.async {
                if self.viewModel.calendarBookingList[self.spaceType]?.isEmpty == false {
                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                }
            }
        case .cancelFailed(let m):
            DialogUtil.showOk(self, m)
        }
    }
}

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.calendarBookingList[spaceType]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.calendarBookingList[spaceType]?[section].bookingList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier:
                                                                "ReservationHeader") as! ReservationHeader
        let item = self.viewModel.calendarBookingList[spaceType]?[section]
        view.dateAsString = item?.dateAsString
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if (self.viewModel.calendarBookingList.count - 1) == section {
            return 100
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            if let booking=viewModel.calendarBookingList[spaceType]?[indexPath.section].bookingList[indexPath.row]{
                let viewController=CancelBookingBuilder.makeBottomSheets(booking: booking) { out in
                    switch(out){
                    case .cancelBooking( _):
                        self.viewModel.cancelBooking(booking)
                    case .dismiss:
                        print("dimiss")
                    }
                }
                self.present(viewController, animated: true, completion: nil)
            }
            
        }
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return S.cancel.localized()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("ReservationTableViewCell", owner: self, options:nil)?.first as! ReservationTableViewCell
        
        let section = indexPath.section
        let row = indexPath.row
        let model=self.viewModel.calendarBookingList[spaceType]?[section]
        let booking = model?.bookingList[row]
        cell.booking = booking
        cell.listener=onEdit(_:)
        if let date=calendarView.selectedDate, let selected=model?.date{
            cell.isSelectedBooking = formatter.string(from: selected)  == formatter.string(from: date)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    private func onEdit(_ booking:BookingModel){
        guard let spaceType=booking.spaceTypeId else{
            return
        }
        if spaceType == SpaceType.meeting.rawValue{
            let viewController=MeetingViewBuilder.build(booking)
            self.navigationController?.pushViewController(viewController, animated: true)
        }else if spaceType == SpaceType.desk.rawValue{
            let viewController=NewOfficeReservationBuilder.make(booking)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
}

extension CalendarViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        let curDate = Date().addingTimeInterval(-24*60*60)
        
        if(date < curDate)
        {
            return false
        }
        else
        {
            return true
        }
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MM"
        
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "dd"
        
        let yearString = yearFormatter.string(from: date)
        let monthString = monthFormatter.string(from: date)
        let dayString = dayFormatter.string(from: date)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        if let dateResult = dateFormatter.date(from: "\(yearString)-\(monthString)-\(dayString)") {
            self.viewModel.selectedDate = dateResult
            self.viewModel.changeMonth(spaceType: spaceType,dateResult)
            self.viewModel.selectBookingListByDate(spaceType:spaceType,dateResult)
        }
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        self.viewModel.selectedDate = calendar.currentPage
        if let date = self.viewModel.selectedDate {
            self.viewModel.changeMonth(spaceType:spaceType,date)
        }
    }
}

extension CalendarViewController: FSCalendarDelegateAppearance {
    
}

extension CalendarViewController: FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return self.viewModel.fetchBookingCountByDate(spaceType: spaceType,date)
    }
}
