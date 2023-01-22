//
//  PublicationTableViewCell.swift
//  FusionCodingChallenge
//
//  Created by John Macy on 1/21/23.
//

import UIKit
import SnapKit
import Kingfisher

class PublicationTableViewCell: UITableViewCell {

    private var lblTitle: UILabel!
    private var lblDate: UILabel!
    private var imgView: UIImageView!

    static let reuseIdentifier = "PublicationTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()

    }

    required init?(coder: NSCoder) {

        super.init(coder: coder)
        setupSubviews()

    }

    override func prepareForReuse() {

        super.prepareForReuse()

        self.imgView.image = nil
        self.lblTitle.text = nil
        self.lblDate.text = nil

    }

    @discardableResult
    func setup(publication: Publication?,
               dateTimeService: DateTimeServiceProtocol) -> Self {

        guard let publication else { return self }

        DispatchQueue.main.async {

            let imgUrl = URL(string: publication.imageUrl)
            self.imgView.kf.setImage(with: imgUrl)

        }

        self.lblTitle.text = publication.title

        let dateString = dateTimeService
            .formattedDateString(
                date: publication.publishedAt,
                format: .longMonthDateYear
            )
        self.lblDate.text = dateString

        return self

    }

    private func setupSubviews() {

        self.imgView = UIImageView()
        self.imgView.contentMode = .scaleAspectFit
        self.imgView.backgroundColor = .black
        self.contentView.addSubview(self.imgView)
        self.imgView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(8.0)
            make.bottom.equalToSuperview().offset(-8.0)
            make.width.equalTo(75.0)
            make.height.equalTo(50.0)
        }

        self.lblTitle = UILabel()
        self.lblTitle.font = UIFont.boldSystemFont(ofSize: 12.0)
        self.lblTitle.numberOfLines = 2
        self.contentView.addSubview(self.lblTitle)
        self.lblTitle.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(8.0)
            make.left.equalTo(self.imgView.snp.right).offset(8.0)
        }

        self.lblDate = UILabel()
        self.lblDate.font = UIFont.systemFont(ofSize: 10.0)
        self.lblDate.setContentHuggingPriority(.defaultHigh, for: .vertical)
        self.contentView.addSubview(self.lblDate)
        self.lblDate.snp.makeConstraints { make in
            make.top.equalTo(self.lblTitle.snp.bottom).offset(8.0)
            make.left.equalTo(self.lblTitle.snp.left)
            make.right.equalToSuperview().inset(8.0)
            make.bottom.equalToSuperview().inset(8.0)
        }

    }

}
