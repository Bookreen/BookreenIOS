//
//  QrReservationViewController+PreviousBookings.swift
//  Bookreen
//
//  Created by bullhead on 12/9/21.
//

import UIKit

extension QrReservationViewController : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return previousBookings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event=previousBookings[indexPath.row]
        let cell=tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        let title="\(event.fixedStart) - \(event.fixedEnd)"
        if #available(iOS 14.0, *) {
            var content=cell.defaultContentConfiguration()
            content.text=title
            content.secondaryText=event.subject
            cell.contentConfiguration=content
        } else {
            cell.textLabel?.text=title
            cell.detailTextLabel?.text=event.subject
        }
        return cell
    }
    
    
}
