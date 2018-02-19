//
//  PlaceTableViewCell.swift
//  NearbyPlaces
//
//  Created by Marto Kenarov on 15.02.18.
//  Copyright © 2018 Marto Kenarov. All rights reserved.
//

import UIKit

class PlaceTableViewCell: UITableViewCell {
    var viewModel: PlaceCellViewModel? {
        didSet {
            bindViewModel()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    private func bindViewModel() {
        self.textLabel?.text = viewModel?.name
        self.detailTextLabel?.text = String(describing: viewModel?.distance)
    }
}
