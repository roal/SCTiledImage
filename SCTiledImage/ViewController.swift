//
//  ViewController.swift
//  SCTiledImage
//
//  Created by Maxime POUWELS on 03/02/2017.
//  Copyright © 2017 siclo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var tiledImageScrollView: SCTiledImageScrollView!
    private var dataSource: ExampleTiledImageDataSource?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTiledImageScrollView()
    }
    
    private func setupTiledImageScrollView() {
        /*//let imageSize = CGSize(width: 9112, height: 4677)
        let imageSize = CGSize(width: 4352, height: 2816)
        let tileSize = CGSize(width: 256, height: 256)
        let zoomLevels = 4
        
        let manager = FileManager.default
        guard let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        print(url)
        
        do {
            let items = try manager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options:[])
            var dir:String = ""
            for item in items {
                print("found \(item)")
                dir = item.lastPathComponent
                print(dir)
            }
            
            dataSource = ExampleTiledImageDataSource(imageSize: imageSize, tileSize: tileSize, zoomLevels: zoomLevels, dir: dir)
            tiledImageScrollView.set(dataSource: dataSource!)
            
        } catch {
            print(error)
        }*/
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "change_map" {
            let destination = segue.destination as? ChangeMapViewController
            destination?.callback = { [self] dir in
                //let imageSize = CGSize(width: 9112, height: 4677)
                //let imageSize = CGSize(width: 4352, height: 2816)
                //let tileSize = CGSize(width: 256, height: 256)
                var imageSize = CGSize(width: 0, height: 0)
                var tileSize = CGSize(width: 0, height: 0)
                var zoomLevels = 0
                
                let manager = FileManager.default
                guard let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first else {
                    return
                }
                let descUrl = url.appendingPathComponent("\(dir)/descriptor.txt")
                do {
                    let content = try String(contentsOf: descUrl).split(whereSeparator: {$0.isNewline})
                    var image_size_width:Int = 0
                    var image_size_height:Int = 0
                    var tile_size_width:Int = 0
                    var tile_size_height:Int = 0
                    
                    for line in content {
                        let values = line.components(separatedBy: "=")
                        
                        if values[0] == "image_size_width" {
                            image_size_width = Int(values[1])!
                        }
                        else if values[0] == "image_size_height" {
                            image_size_height = Int(values[1])!
                        }
                        else if values[0] == "tile_size_width" {
                            tile_size_width = Int(values[1])!
                        }
                        else if values[0] == "tile_size_height" {
                            tile_size_height = Int(values[1])!
                        }
						else if values[0] == "levels" {
                            zoomLevels = Int(values[1])!
                        }
                    }
                    
                    print("descriptor image(\(image_size_width), \(image_size_height)); tile(\(tile_size_width), \(tile_size_height))")
                    imageSize = CGSize(width: image_size_width, height: image_size_height)
                    tileSize = CGSize(width: tile_size_width, height: tile_size_height)
                }
                catch {
                    print("descriptor file not found : \(descUrl), or regex bad")
                }
                
                self.dataSource = ExampleTiledImageDataSource(imageSize: imageSize, tileSize: tileSize, zoomLevels: zoomLevels, dir: dir)
                self.tiledImageScrollView.set(dataSource: self.dataSource!)
                
            }
        }
    }
    
}
