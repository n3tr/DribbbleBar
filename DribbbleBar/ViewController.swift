//
//  ViewController.swift
//  DribbbleBar
//
//  Created by Jirat Ki. on 11/5/2559 BE.
//  Copyright © 2559 Jirat Ki. All rights reserved.
//

import Cocoa
import SDWebImage

class ViewController: NSViewController {
    
    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var imageView: NSImageView!
    static let itemViewIdentifier = "ThumbnailItemViewIdentifier"
    
    var shots: [Shot] = []

    @IBOutlet weak var scrubber: NSScrubber!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = NSScrubberFlowLayout()
        layout.itemSize = NSSize(width: 40, height: 30)
        layout.itemSpacing = 0
        
        scrubber.register(ThumbnailItemView.self, forItemIdentifier: ViewController.itemViewIdentifier)
        scrubber.mode = .free
        scrubber.selectionBackgroundStyle = .roundedBackground
        scrubber.delegate = self
        scrubber.dataSource = self
        scrubber.selectionOverlayStyle = NSScrubberSelectionStyle.outlineOverlay
        scrubber.scrubberLayout = layout
        
        fetchShots()
        
        
    }

}

extension ViewController: NSScrubberDelegate, NSScrubberDataSource {
    func numberOfItems(for scrubber: NSScrubber) -> Int {
        return shots.count
    }
    
    func scrubber(_ scrubber: NSScrubber, viewForItemAt index: Int) -> NSScrubberItemView {
        let itemView = scrubber.makeItem(withIdentifier: ViewController.itemViewIdentifier, owner: nil) as! ThumbnailItemView
        let shot = shots[index]
        itemView.imageURL = URL(string: shot.teaserImage)
        
        return itemView
    }
    
    func scrubber(_ scrubber: NSScrubber, didSelectItemAt selectedIndex: Int) {
        let shot = self.shots[selectedIndex]
        titleLabel.stringValue = shot.title
        imageView.sd_setImage(with: URL(string: shot.normalImage))
    }
}


// MARK: - API
extension ViewController {
    
    static let popularShotURL = URL(string: "https://api.dribbble.com/v1/shots?per_page=50&access_token=865c0ec9f1388e9df68a4a2d55d54d9bcfbe330b4e5b3bf9529cfc819b5f7b63")!
    func fetchShots() {
        URLSession.shared.dataTask(with: ViewController.popularShotURL, completionHandler: { (data, _, error) in
            guard let data = data else {
                print(error)
                return
            }
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [AnyObject] else {
                return
            }
            
            self.shots = json!.map({ (shotJson) -> Shot in
                let shot = Shot(json: shotJson)
                return shot
            })
            
            DispatchQueue.main.async {
                self.scrubber.reloadData()
                
            }
            
            
            
        }).resume()
    }
}

