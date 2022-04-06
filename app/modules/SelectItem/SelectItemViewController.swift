import Foundation
import UIKit

final class SelectItemViewController: AppViewController {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomConstraintOfTableView: NSLayoutConstraint!
    
    var viewModel: SelectItemViewModelProtocol!
    var callback: ((SelectItemResult) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        
        self.labelTitle.text = self.viewModel.title
        self.configureTableView()
    }
    
    private func configureTableView() {
        self.bottomConstraintOfTableView.constant = self.getSafeAreaInsetsBottom()
        self.tableView.tableFooterView = UIView()
        self.tableView.allowsSelection = true
        self.tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.viewModel.loadItemList()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.viewModel.delegate = nil
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
    }
    
    @IBAction func pressedButtonDismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension SelectItemViewController: SelectItemViewModelDelegate {
    func handleOutput(_ output: SelectItemViewOutput) {
        switch output {
        case .LoadedItemList:
            self.tableView.reloadData()
        case .showLoading(let isLoading):
            print(isLoading)
        }
    }
}

extension SelectItemViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.list.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let selectedItem = self.viewModel.list[index]
        
        var campus: CampusModel? = nil
        var building: BuildingModel? = nil
        var floor: FloorModel? = nil
        
        switch self.viewModel.itemType {
        case .campus:
            let filterResult = self.viewModel.campusList.filter({ item in
                return item.id == selectedItem.id
            })
            if filterResult.count > 0 {
                campus = filterResult[0]
            }
        case .building:
            let filterResult = self.viewModel.buildingList.filter({ item in
                return item.id == selectedItem.id
            })
            if filterResult.count > 0 {
                building = filterResult[0]
            }
        case .floor:
            let filterResult = self.viewModel.floorList.filter({ item in
                return item.id == selectedItem.id
            })
            if filterResult.count > 0 {
                floor = filterResult[0]
            }
        }
        
        self.dismiss(animated: true) {
            self.callback?(SelectItemResult(itemType: self.viewModel.itemType, campus: campus, building: building, floor: floor))
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("ItemTableViewCell", owner: self, options:nil)?.first as! ItemTableViewCell
        let index = indexPath.row
        cell.item = self.viewModel.list[index]
        cell.selectionStyle = .none
        return cell
    }
}
