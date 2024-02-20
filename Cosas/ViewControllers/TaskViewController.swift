//
//  TaskViewController.swift
//  Cosas
//
//  Created by Антон Пеньков on 17.02.2024.
//

import UIKit

final class TaskViewController: UIViewController {
    
    // MARK: - Properties
    weak var task: ToDoTask?
    weak var delegate: NewTaskViewControllerDelegate?
    private let storageManager = StorageManager.shared
    
    // MARK: - UI Elements
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = task == nil ? "New Task" : "Edit Task"
        label.textColor = .darkBlue
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 42, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title:"
        label.textColor = .darkBlue
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var noteLabel: UILabel = {
        let label = UILabel()
        label.text = "Note:"
        label.textColor = .darkBlue
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Task Name"
        textField.borderStyle = .roundedRect
        textField.text = task == nil ? "" : task?.title
        textField.textAlignment = .right
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var noteTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Note"
        textField.borderStyle = .roundedRect
        textField.text = task == nil ? "" : task?.note
        textField.textAlignment = .right
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var saveButton: UIButton = {
        let filledButtonFactory = FilledButtonFactory(
            title: "Save",
            color: .floralGreen,
            action: UIAction { [unowned self] _ in
                if headerLabel.text == "New Task" {
                    save()
                } else {
                    edit()
                }
            }
        )
        return filledButtonFactory.createButton()
    }()
    
    private lazy var cancelButton: UIButton = {
        let filledButtonFactory = FilledButtonFactory(
            title: "Cancel",
            color: .floralRed,
            action: UIAction { [unowned self] _ in
                dismiss(animated: true)
            }
        )
        return filledButtonFactory.createButton()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .floralwhite
        setupSubviews(
            headerLabel,
            titleLabel,
            noteLabel,
            titleTextField,
            noteTextField,
            saveButton,
            cancelButton
        )
        setupConstraints()
    }
    
    // MARK: - Private Methods
    private func save() {
        storageManager.save(
            titleTextField.text ?? "",
            withNote: noteTextField.text ?? ""
        )
        delegate?.reloadData()
        dismiss(animated: true)
    }
    
    private func edit() {
        guard let task else { return }
        storageManager.edit(
            task,
            newTitle: titleTextField.text ?? "",
            newNote: noteTextField.text ?? ""
        )
        delegate?.reloadData()
        dismiss(animated: true)
    }
}

// MARK: - Setup UI
private extension TaskViewController {
    func setupSubviews(_ subviews: UIView...) {
        subviews.forEach { subview in
            view.addSubview(subview)
        }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -250)
        ])
        
        NSLayoutConstraint.activate([
            noteLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            noteLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0),
            noteLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 200)
        ])
        
        NSLayoutConstraint.activate([
            titleTextField.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            titleTextField.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            noteTextField.topAnchor.constraint(equalTo: noteLabel.bottomAnchor, constant: 16),
            noteTextField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0),
            noteTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: noteTextField.bottomAnchor, constant: 16),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
        
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 16),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
}

#Preview {
    TaskViewController()
}
