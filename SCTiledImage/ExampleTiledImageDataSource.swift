//
//  ExampleTiledImageDataSource.swift
//  SCTiledImage
//
//  Created by Maxime POUWELS on 03/02/2017.
//  Copyright © 2017 siclo. All rights reserved.
//

import UIKit

class ExampleTiledImageDataSource: SCTiledImageViewDataSource {
    
    weak var delegate: SCTiledImageViewDataSourceDelegate?
    
    let imageSize: CGSize
    let tileSize: CGSize
    let zoomLevels: Int
    var dir:String = ""
    
    init(imageSize: CGSize, tileSize: CGSize, zoomLevels: Int, dir: String) {
        self.imageSize = imageSize
        self.tileSize = tileSize
        self.zoomLevels = zoomLevels
        self.dir = dir
    }
    
    func requestTiles(_ tiles: [SCTile]) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            var res: [(SCTile, UIImage)] = []
            for tile in tiles {
                let manager = FileManager.default
                guard let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first else {
                    return
                }
                let imageUrl = url.appendingPathComponent("\(self!.dir)/\(tile.level)-\(tile.col)-\(tile.row).jpg")
                
                if let image = UIImage(contentsOfFile: imageUrl.path) {
                   res.append((tile, image))
                }
            }
            self?.delegate?.didRetrieve(tilesWithImage: res)
        }
    }
    
    func requestBackgroundImage(completionHandler: @escaping (UIImage?) -> ()) {
        DispatchQueue.global(qos: .userInitiated).async {
            let name = "background.jpg"
            let image = UIImage(named: name)
            DispatchQueue.main.async {
                completionHandler(image)
            }
        }
    }
    
    func getCachedImage(for tile: SCTile) -> UIImage? {
        return nil
    }
    
}
