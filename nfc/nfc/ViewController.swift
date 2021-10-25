//
//  ViewController.swift
//  nfc
//
//  Created by Sepuh on 28.09.21.
//

import UIKit
import Foundation
import CoreNFC


class Cell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
}


class ViewController: UITableViewController, NFCNDEFReaderSessionDelegate {
    
    
    var detectedMessages: [NFCNDEFMessage] = []
    
    var session: NFCNDEFReaderSession?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detectedMessages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Cell
        cell.name.text = String(indexPath.row)
        return cell
    }
    
    @IBAction func beginScanning(_ sender: Any) {
        guard NFCNDEFReaderSession.readingAvailable else {
            let alertController = UIAlertController(
                title: "Scanning Not Supported",
                message: "This device doesn't support tag scanning.",
                preferredStyle: .alert
            )
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            for _ in 1...100 {
                print("can not read")
            }
            return
        }
        
        session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
        session?.alertMessage = "Hold your iPhone near the item to learn more about it."
        session?.begin()
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        DispatchQueue.main.async {
            // Process detected NFCNDEFMessage objects.
            self.detectedMessages.append(contentsOf: messages)
            for _ in 1...100 {
                print(messages)
            }
            self.tableView.reloadData()
        }
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print(error)
    }
}
