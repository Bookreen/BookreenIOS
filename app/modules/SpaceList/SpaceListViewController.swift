import Foundation
import UIKit

final class SpaceListViewController: AppViewController {
    
    @IBOutlet weak var filterButton: UIImageView!
    @IBOutlet weak var timerView: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let spacing: CGFloat = 0

    var callback: ((ReservationSpaceModel) -> Void)?
    var viewModel: SpaceListViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filterButton.isUserInteractionEnabled=true
        filterButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pressedButtonFilter)))
        [S.all,S.recently,S.frequently,S.favorites]
            .enumerated()
            .forEach {
                timerView.setTitle($0.element.localized(), forSegmentAt: $0.offset)
            }
        self.configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeSelectedOfficeHandler(_:)), name: .didChangeSelectedOffice, object: nil)
        self.viewModel.delegate = self
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.viewModel.searchBooking()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        self.viewModel.delegate = nil
        self.collectionView.delegate = nil
        self.collectionView.dataSource = nil
    }
    @IBAction func onTimeTap(_ sender: Any) {
        viewModel.selectedTag=timerView.selectedSegmentIndex+1
    }
    
    @objc func didChangeSelectedOfficeHandler(_ notification: Notification) {
        if let data = notification.userInfo as? [String: String] {
            let campusId = data["campusId"] ?? ""
            let campusTitle = data["campusTitle"] ?? ""
            let buildingId = data["buildingId"] ?? ""
            let buildingTitle = data["buildingTitle"] ?? ""
            let floorId = data["floorId"] ?? ""
            let floorTitle = data["floorTitle"] ?? ""
            let spaceId = data["spaceId"] ?? ""
            let spaceTitle = data["spaceTitle"] ?? ""
            
            let oldPresenter = self.viewModel.presenter
            self.viewModel.presenter = SpaceListViewPresenter(
                planDate: oldPresenter.planDate,
                startTime: oldPresenter.startTime,
                endTime: oldPresenter.endTime,
                selectedSpace: ReservationSpaceModel(
                    spaceId: spaceId,
                    spaceName: spaceTitle,
                    campusId: campusId,
                    campusName: campusTitle,
                    buildingId: buildingId,
                    buildingName: buildingTitle,
                    floorId: floorId,
                    floorName: floorTitle
                )
            )
            self.viewModel.searchBooking()
        }
    }
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: self.spacing, left: self.spacing, bottom: self.spacing, right: self.spacing)
        layout.minimumLineSpacing = self.spacing
        layout.minimumInteritemSpacing = self.spacing
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = CGSize(width: self.view.frame.width - (self.spacing * 2), height: 232)
        
        self.collectionView.collectionViewLayout = layout
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: self.spacing, bottom: 0, right: self.spacing)
        self.collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: self.spacing, bottom: 0, right: self.spacing)
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.alwaysBounceVertical = false
        self.collectionView.alwaysBounceHorizontal = false
        
        let nib = UINib(nibName: SpaceGroupCollectionViewCell.nibName, bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: SpaceGroupCollectionViewCell.reuseIdentifier)

    }
    
    
    @objc private func pressedButtonFilter() {
        let viewController = SelectSeatingArrangementBuilder.makeBottomSheets(layoutId: self.viewModel.layoutId) { layoutId in
            if layoutId > 0 {
                self.viewModel.layoutId = layoutId
            } else {
                self.viewModel.layoutId = layoutId
            }
        }
        self.present(viewController, animated: true, completion: nil)
    }
}


extension SpaceListViewController: SpaceListViewModelDelegate {
    func handleOutput(_ output: SpaceListViewOutput) {
        switch output {
        case .loadedSpaceGroupList:
            self.collectionView.reloadData()
        }
    }
}

extension SpaceListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.filterSpaceGroups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SpaceGroupCollectionViewCell.reuseIdentifier,
                                                         for: indexPath) as? SpaceGroupCollectionViewCell {
            cell.spaceGroup = self.viewModel.filterSpaceGroups[indexPath.row]
            cell.delegate = self
            cell.spaceHorizontalCollectionViewCellDelegate = self
            return cell
        }
        return UICollectionViewCell()
    }
}

extension SpaceListViewController: SpaceHorizontalCollectionViewCellDelegate {
    func spaceHorizontalCollectionViewCell(_ view: SpaceHorizontalCollectionViewCell, addFavorite: SpaceModel) {
        if (addFavorite.isMyFavorite ?? "false") == "true" {
            self.viewModel.removeFavorite(space: addFavorite)
        } else {
            self.viewModel.addFavorite(space: addFavorite)
        }
    }
}

extension SpaceListViewController: SpaceGroupCollectionViewCellDelegate {
    func spaceGroupCollectionViewCell(_ view: SpaceGroupCollectionViewCell, spaceGroup: SearchBookingResponse) {
        let planDate = self.viewModel.presenter.planDate
        let spaceGroups = self.viewModel.spaceGroups
        let viewController = DepartmentBuilder.make(spaceType:viewModel.spaceType,planDate: planDate, spaceGroup: spaceGroup, spaceGroups: spaceGroups) { result in
            let reservationSpace = ReservationSpaceModel(
                spaceId: result.id,
                spaceName: result.name,
                campusId: result.campusId,
                campusName: result.campusName,
                buildingId: result.buildingId,
                buildingName: result.buildingName,
                floorId: result.floorId,
                floorName: result.floorName
            )
            self.callback?(reservationSpace)
        }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func spaceGroupCollectionViewCell(_ view: SpaceGroupCollectionViewCell, didSelectedSpace: SpaceModel) {
        let reservationSpace = ReservationSpaceModel(
            spaceId: didSelectedSpace.id,
            spaceName: didSelectedSpace.name,
            campusId: didSelectedSpace.campusId,
            campusName: didSelectedSpace.campusName,
            buildingId: didSelectedSpace.buildingId,
            buildingName: didSelectedSpace.buildingName,
            floorId: didSelectedSpace.floorId,
            floorName: didSelectedSpace.floorName
        )
        self.callback?(reservationSpace)
    }
}
