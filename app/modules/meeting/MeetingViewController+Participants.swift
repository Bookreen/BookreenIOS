//
//  MeetingViewController+Participants.swift
//  Bookreen
//
//  Created by bullhead on 12/2/21.
//

import UIKit

extension MeetingViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func setupParticipants(){
        if let id=self.id{
            BookingService.instance
                .bookingDetails(id: id)
                .subscribe { model in
                    if let p=model.participants{
                        self.participants=p
                        self.showParticipants()
                    }
                } onFailure: { error in
                    print(error.localizedDescription)
                    self.showParticipants()
                }.disposed(by: bag)
        }else{
            showParticipants()
        }
        
    }
    
    private func showParticipants(){
        let fake=ParticipantModel(id: "-1", email: "", name: S.addParticipant.localized(), surname: "", profilePhoto: "local", companyId: "", companyName: "")
        if participants.count > 0 {
            participants.insert(fake ,at: 0)
        }else{
            participants.append(fake)
        }
        participantCollectionView.register(ParticipantCell.create(), forCellWithReuseIdentifier: "cell")
        participantCollectionView.delegate=self
        participantCollectionView.dataSource=self
        participantCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return participants.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ParticipantCell
        cell.bind(participants[indexPath.row])
        cell.listener = self.onTap(_:)
        return cell
    }
    
    private func onTap(_ participant:ParticipantModel){
        if participant.id=="-1"{
            openSearch()
        }else{
            showDelete(participant)
        }
    }
    
    private func showDelete(_ participant:ParticipantModel){
        let alert=UIAlertController(title: S.removeParticipantMessage.localized().replacingOccurrences(of: "%s", with: participant.fullname), message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: S.yes.localized(), style: .destructive, handler: { _ in
            self.delete(participant)
        }))
        alert.addAction(UIAlertAction(title: S.no.localized(), style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func delete(_ participant:ParticipantModel){
        if let index=participants.firstIndex(where: {$0.id==participant.id}){
            participants.remove(at: index)
            participantCollectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
            getAutoSpace()
        }
    }
    
    private func openSearch(){
        let controller=SearchFriendBuilder.make(true,callback: {_ in}) { model in
            if self.participants.contains(where: {$0.email==model.email}){
                return
            }
            self.participants.append(model)
            self.participantCollectionView.reloadData()
            self.getAutoSpace()
        }
        self.present(controller, animated: true, completion: nil)
    }
    
    
}
