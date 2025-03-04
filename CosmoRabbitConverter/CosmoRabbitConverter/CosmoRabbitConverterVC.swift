//
//  ConverterVC.swift
//  CosmoRabbitConverter
//
//  Created by CosmoRabbit Converter on 2025/3/4.
//


import UIKit

class CosmoRabbitConverterVC: UIViewController {
    
    
    @IBOutlet weak var converterTableView: UITableView!
    
    
    var converter = CosmoRabbitSpace
    var expandedSection: Int? = nil
    
    @IBOutlet weak var privacyButton: UIButton!
    
    @IBOutlet weak var shareButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        converterTableView.register(UINib(nibName: "TableViewHeaderCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "TableViewHeaderCell")
        converterTableView.register(UINib(nibName: "ConverterCell", bundle: nil), forCellReuseIdentifier: "ConverterCell")
        
        converterTableView.delegate = self
        converterTableView.dataSource = self
        if #available(iOS 15.0, *) {
            converterTableView.sectionHeaderTopPadding = 0
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    
    @IBAction func shareAction(_ sender: Any) {
        let textToShare = "CosmoRabbit Converter is a space-themed unit conversion app designed for explorers who want to see how everyday Earth measurements compare across the cosmos. "
        if let appURL = URL(string: "https://apps.apple.com/app/id\(appid)") {
            let items: [Any] = [textToShare, appURL]
            let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
            if let popoverController = activityVC.popoverPresentationController {
                popoverController.barButtonItem = navigationItem.rightBarButtonItem
            }
            present(activityVC, animated: true, completion: nil)
        }
    }
}

extension CosmoRabbitConverterVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return converter.count
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (expandedSection == section) ? converter[section].space.count : 0
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableViewHeaderCell") as! TableViewHeaderCell
        
        let headerData = converter[section].title
        viewHeader.titleLabel.text = headerData
        viewHeader.section = section
        
        let isExpanded = (expandedSection == section)
        viewHeader.updateButtonImage(isExpanded: isExpanded)
        
        // Handle section toggle
        viewHeader.buttonAction = { [weak self] selectedSection in
            guard let self = self else { return }
            
            let previousExpandedSection = self.expandedSection
            
            // Toggle expansion logic
            if self.expandedSection == selectedSection {
                self.expandedSection = nil  // Collapse if already expanded
            } else {
                self.expandedSection = selectedSection  // Expand new section
            }
            
            // Reload the whole table instead of sections (avoids batch update errors)
            self.converterTableView.reloadData()
            
            // Optional: Scroll to make the expanded section visible
            if let expandedSection = self.expandedSection {
                self.converterTableView.scrollToRow(at: IndexPath(row: 0, section: expandedSection), at: .top, animated: true)
            }
        }
        
        return viewHeader
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = converterTableView.dequeueReusableCell(withIdentifier: "ConverterCell", for: indexPath) as! ConverterCell
        cell.titleLable.text = converter[indexPath.section].space[indexPath.row].name
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ConverResultVC") as! CosmoRabbitConverResultVC
        let selectedIndex = converter[indexPath.section].space[indexPath.row]
        
        vc.from = selectedIndex.convertFrom
        vc.to = selectedIndex.convertTo
        vc.valueName = selectedIndex.valueName
        vc.unitValue = selectedIndex.value
        vc.nameTitle = selectedIndex.name
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
    
    
    
    
    
}
