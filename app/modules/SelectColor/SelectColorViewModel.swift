import Foundation

protocol SelectColorViewModelDelegate {
    func successLoadedColors()
}

protocol SelectColorViewModelProtocol {
    var delegate: SelectColorViewModelDelegate? { get set }
    var colors: [String] { get set }
    func getColors()
}

final class SelectColorViewModel: SelectColorViewModelProtocol {
    
    var delegate: SelectColorViewModelDelegate?
    var colors: [String] = []
    
    func getColors() {
        self.colors = []
        self.colors.append("#2062af")
        self.colors.append("#58AEB7")
        self.colors.append("#F4B528")
        self.colors.append("#DD3E48")
        self.colors.append("#BF89AE")
        self.colors.append("#5C88BE")
        self.colors.append("#59BC10")
        self.colors.append("#E87034")
        self.colors.append("#F84C44")
        self.colors.append("#8C47FB")
        self.colors.append("#51C1EE")
        self.colors.append("#8CC453")
        self.colors.append("#C2987D")
        self.colors.append("#CE7777")
        self.colors.append("#9086BA")
        self.delegate?.successLoadedColors()
    }
}
