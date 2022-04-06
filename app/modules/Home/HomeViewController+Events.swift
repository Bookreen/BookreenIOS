//
//  HomeViewController+Events.swift
//  Bookreen
//
//  Created by bullhead on 12/4/21.
//

import UIKit

extension HomeViewController{
    func toggleEvents(meeting:Bool){
        if meeting{
            labelStatus.text=S.noMeetings.localized()
            imageViewStatus.image=UIImage(named: "no_meeting")
            currentSpaceType = .meeting
        }else{
            labelStatus.text=S.youAreAtHomeToday.localized()
            currentSpaceType = .desk
            imageViewStatus.image=UIImage(named: "at_home")
        }
        updateDisplayBooking()
    }
    
    func updateDisplayBooking(){
        displayBookings=viewModel.todayBookingList.filter({$0.spaceTypeId == self.currentSpaceType.rawValue})
        self.viewStatusContainer.alpha = self.displayBookings.count > 0 ? 0.0 : 1.0
        self.viewStatusContainer.isUserInteractionEnabled = self.viewModel.todayBookingList.count == 0
        
        self.collectionView.alpha = self.displayBookings.count > 0 ? 1.0 : 0.0
        self.collectionView.isUserInteractionEnabled = displayBookings.count > 0
        self.collectionView.reloadData()
        self.updateLabelCalendar()
    }
    
    func updateLabelCalendar() {
        if displayBookings.isEmpty {
            self.labelCalendarTopConstraint.constant = self.topConstraintNoActiveBooking
        } else {
            self.labelCalendarTopConstraint.constant = self.topConstraintActiveBooking
        }
    }
}
