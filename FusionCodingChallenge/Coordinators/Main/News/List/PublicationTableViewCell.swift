//
//  PublicationTableViewCell.swift
//  FusionCodingChallenge
//
//  Created by John Macy on 1/21/23.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa

protocol PublicationTableViewCellProtocol {

    var lblTitle: UILabel! { get }
    var lblDate: UILabel! { get }
    var imgView: UIImageView! { get }

}

class PublicationTableViewCell: UITableViewCell, PublicationTableViewCellProtocol {

    private(set) var lblTitle: UILabel!
    private(set) var lblDate: UILabel!
    private(set) var imgView: UIImageView!

    static let reuseIdentifier = "PublicationTableViewCell"
    static let rowHeight = 66.0

    private var viewModel: PublicationTableViewCellViewModel!
    private var dateTimeService: DateTimeServiceProtocol!

    private var disposeBag: DisposeBag!

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

        self.disposeBag = nil

    }

    @discardableResult
    func setup(viewModel: PublicationTableViewCellViewModel) -> Self {

        self.viewModel = viewModel
        self.dateTimeService = dateTimeService
        setupBindings()

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

    private func setupBindings() {

        self.disposeBag = DisposeBag()

        self.viewModel.title
            .bind{ [weak self] in
                self?.lblTitle.text = $0
            }
            .disposed(by: self.disposeBag)

        self.viewModel.date
            .bind{ [weak self] in
                self?.lblDate.text = $0
            }
            .disposed(by: self.disposeBag)

        self.viewModel.imgUrl
            .bind{ [weak self] in

                if let urlString = $0 {

                    let imgUrl = URL(string: urlString)
                    self?.imgView.kf.setImage(with: imgUrl)

                }

            }
            .disposed(by: self.disposeBag)

    }

}
