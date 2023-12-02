//
//  HomeViewController.swift
//  Team9_MAPD714_Project-Milestone2
//
//  Created by Anmol Sharma on 2023-11-28.
//
//
//  Team Number: 9
//  Milestone Number: 2
//
//  Team Members:
//  Shubham Patel - 301366205
//  Anmol Sharma - 301364872
//  Submission date - 1 Dec 2023
//
//  Date picker customisation


import UIKit

class DatePickerView: UIView {
    var onDateSelected: ((Date) -> Void)?

    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.minimumDate = Date()
        return picker
    }()

    private let doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        backgroundColor = .white

        addSubview(datePicker)
        addSubview(doneButton)

        datePicker.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: topAnchor),
            datePicker.leadingAnchor.constraint(equalTo: leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: trailingAnchor),

            doneButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor),
            doneButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            doneButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            doneButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            doneButton.heightAnchor.constraint(equalToConstant: 40),
        ])

        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }

    @objc private func doneButtonTapped() {
        onDateSelected?(datePicker.date)
    }
}

