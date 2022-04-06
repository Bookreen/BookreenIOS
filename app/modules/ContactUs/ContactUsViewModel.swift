import Foundation

enum ContactUsViewOutput {
    case showLoading(Bool)
    case isValidInput(Bool)
    case successGiveFeedback
    case failureGiveFeedback
    case handleError(Error)
}

protocol ContactUsViewModelProtocol {
    var delegate: ContactUsViewModelDelegate? { get set }
    func validInputs(subject: String, message: String)
    func giveFeedback(subject: String, message: String)
}

protocol ContactUsViewModelDelegate {
    func handleOutput(_ output: ContactUsViewOutput)
}

final class ContactUsViewModel: ContactUsViewModelProtocol {
    
    var delegate: ContactUsViewModelDelegate?
    
    private let bookreenService: BookreenServiceProtocol
    
    init(bookreenService: BookreenServiceProtocol) {
        self.bookreenService = bookreenService
    }
    
    func validInputs(subject: String, message: String) {
        let isValid = !subject.isEmpty && !message.isEmpty
        self.delegate?.handleOutput(.isValidInput(isValid))
    }
    
    func giveFeedback(subject: String, message: String) {
        self.delegate?.handleOutput(.showLoading(true))
        let input = GiveFeedbackInput(subject: subject, message: message)
        self.bookreenService.giveFeedback(input: input) { result in
            self.delegate?.handleOutput(.showLoading(false))
            switch result {
            case .success(_, let output):
                if output.status {
                    self.delegate?.handleOutput(.successGiveFeedback)
                } else {
                    self.delegate?.handleOutput(.failureGiveFeedback)
                }
            case .failure(let error):
                self.delegate?.handleOutput(.handleError(error))
            }
        }
    }
}
