import Foundation
import UIKit

final class SelectColorViewController: AppViewController {
    
    var viewModel: SelectColorViewModelProtocol!
    var callback: ((String) -> Void)?
        
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var viewLine: UIView!
    
    override func viewDidLoad() {
        self.viewLine.backgroundColor = ColorPalette.shared.colorBlack
        self.viewLine.alpha = 0.5
        self.labelTitle.text = S.selectColor.localized()
        
        self.collectionView.register(UINib(nibName: "ColorCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ColorCollectionViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewModel?.delegate = self
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.viewModel.getColors()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.viewModel?.delegate = nil
        self.collectionView.delegate = nil
        self.collectionView.dataSource = nil
    }
    
    @IBAction func pressedButtonClose(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension SelectColorViewController: SelectColorViewModelDelegate {
    func successLoadedColors() {
        self.collectionView.reloadData()
    }
}

extension SelectColorViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = self.viewModel else { fatalError("ViewModel is not initialized") }
        let index = indexPath.row
        let color = viewModel.colors[index]
        self.callback?(color)
        dismiss(animated: true, completion: nil)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = self.viewModel else { fatalError("ViewModel is not initialized") }
        return viewModel.colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewModel = self.viewModel else { fatalError("ViewModel is not initialized") }
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCollectionViewCell", for: indexPath) as! ColorCollectionViewCell
        let index = indexPath.row
        cell.color = viewModel.colors[index]
        return cell
    }
}
