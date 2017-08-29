//
//  pdfDataSource.swift
//  grant-pdf-viewer
//
//  Created by Phil Hauser on 03/08/2015.
//  Copyright (c) 2015 Phil Hauser. All rights reserved.
//

import Foundation
import UIKit

struct ColorMapObject {
    let section: String
    let color: UIColor
}

struct PdfObject {
    let type: String
    let name: String
    let parent: String
    let group: String?
    let section: String
}

class ThemeApp {
    var colorThemes: [ColorMapObject] = []
    
    init(){
        colorThemes.append(ColorMapObject(section: "Oil", color: UIColor(red: 0.0/255.0, green: 133.0/255.0, blue: 62.0/255.0, alpha: 1.0)))
        colorThemes.append(ColorMapObject(section: "Biomass", color: UIColor(red: 78.0/255.0, green: 18.0/255.0, blue: 2.0/255.0, alpha: 1.0)))
        colorThemes.append(ColorMapObject(section: "Solar Thermal", color: UIColor(red: 249.0/255.0, green: 198.0/255.0, blue: 46.0/255.0, alpha: 1.0)))
        colorThemes.append(ColorMapObject(section: "Heat Pump", color: UIColor(red: 95.0/255.0, green: 99.0/255.0, blue: 105.0/255.0, alpha: 1.0)))
        colorThemes.append(ColorMapObject(section: "Cylinder", color: UIColor(red: 0.0/255.0, green: 153.0/255.0, blue: 217.0/255.0, alpha: 1.0)))
        colorThemes.append(ColorMapObject(section: "Controls", color: UIColor(red: 84.0/255.0, green: 185.0/255.0, blue: 72.0/255.0, alpha: 1.0)))
        colorThemes.append(ColorMapObject(section: "Hybrid", color: UIColor(red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0, alpha: 1.0)))
    }
    
    
    func get(_ index: Int) -> ColorMapObject {
        return colorThemes[index]
    }

    
    func getColorForSection(_ section: String) -> UIColor{
        var matchedColorTheme: UIColor
        matchedColorTheme = self.get(0).color

        for colorTheme in colorThemes {
            if(colorTheme.section == section){
                matchedColorTheme = colorTheme.color;
            }
        }
        
        return matchedColorTheme
    }
}

class PdfStore {
    class var sharedInstance: PdfStore {
        struct Static {
            static let instance = PdfStore()
        }
        return Static.instance
    }
    
    var pdfObjects: [PdfObject] = []
    var arrayForGivenParent: [PdfObject] = []
    var rootArray: [PdfObject] = []
    
    var count: Int {
        return pdfObjects.count
    }
    
    var countPdfsForParent: Int {
        return arrayForGivenParent.count
    }
    
    var countPdfsForRoot: Int {
        return rootArray.count
    }
    
    func emptyArrayForGivenParent (){
        self.arrayForGivenParent.removeAll()
    }
    
    
    func pdfsForRoot() -> [PdfObject]{
        
        if count == 0 {
            prepop()
        }
        
        if (rootArray.count < 1){
            
            for pdfObject in pdfObjects {

                if pdfObject.parent == "/" {
                    rootArray.append(pdfObject)
                }
                
            }
            
        }

        return rootArray
        
    }
    
    
    func pdfsForParent(_ name: String, selectedRouteObject: PdfObject) -> [PdfObject]{
        
        // Empty the array that will be pushed into the table view
        self.emptyArrayForGivenParent()
        
        // If the data store is empty, fill it
        if count == 0 {
            prepop()
        }
        
        // Loop through the data store
        for pdfObject in pdfObjects {
        
            // If the name of the selected table cell matches the parent of a pdf object
            if pdfObject.parent == name {
                
                // And if it has a group
                if pdfObject.group != nil {
                    
                    // And if that group matches the parent of the parent of the selected cell and it is in the correct section
                    if pdfObject.group == selectedRouteObject.parent && pdfObject.section == selectedRouteObject.section {
                        
                        // then push it into the array for the next table view
                        arrayForGivenParent.append(pdfObject)
                    }
                }else{
                    if pdfObject.section == selectedRouteObject.section {
                        // else if it has no group, push it into the array for the next table view
                        arrayForGivenParent.append(pdfObject)
                    } else if pdfObject.parent == "/" {
                        arrayForGivenParent.append(pdfObject)
                    }
                }
            }
            

        }
        return arrayForGivenParent
        
    }
    
    func prepop(){
        // Oil
        pdfObjects.append(PdfObject(type: "dir", name: "Oil", parent: "/", group: nil, section: "Oil"))
            // Accessories
            pdfObjects.append(PdfObject(type: "dir", name: "Accessories", parent: "Oil", group: nil, section: "Oil"))
                // Mag One
                pdfObjects.append(PdfObject(type: "dir", name: "Mag One", parent: "Accessories", group: nil, section: "Oil"))
                    // Current
                    pdfObjects.append(PdfObject(type: "dir", name: "Current", parent: "Mag One", group: nil, section: "Oil"))
                        pdfObjects.append(PdfObject(type: "pdf", name: "Grant UK MagOne data sheet - August 2015", parent: "Current", group: "Mag One", section: "Oil"))
                        pdfObjects.append(PdfObject(type: "pdf", name: "Grant UK Vortex Mag-One Magnetic Filter Installation and Servicing manual - DOC98 Rev 1-1 - October 2015", parent: "Current", group: "Mag One", section: "Oil"))
        
                    // Archive
                    pdfObjects.append(PdfObject(type: "dir", name: "Archive", parent: "Mag One", group: nil, section: "Oil"))
                        pdfObjects.append(PdfObject(type: "pdf", name: "Grant Mag-One Magnetic Filter manual - DOC98 Rev00 - September 2014", parent: "Archive", group: "Mag One", section: "Oil"))
                        pdfObjects.append(PdfObject(type: "pdf", name: "Grant Mag One Magnetic Filter Installation and Servicing manual - DOC98 Rev01 - December 2014", parent: "Archive", group: "Mag One", section: "Oil"))
                        pdfObjects.append(PdfObject(type: "pdf", name: "Grant UK Vortex Mag-One Magnetic Filter - DOC98 Rev 1-0 - August 2015", parent: "Archive", group: "Mag One", section: "Oil"))


                // Timers Programmers
                pdfObjects.append(PdfObject(type: "dir", name: "Timers Programmers", parent: "Accessories", group: nil, section: "Oil"))
                    // Current
                    pdfObjects.append(PdfObject(type: "dir", name: "Current", parent: "Timers Programmers", group: nil, section: "Oil"))
                        pdfObjects.append(PdfObject(type: "pdf", name: "EPKIT installation and user instructions - DOC19 Rev04 - May 2011", parent: "Current", group: "Timers Programmers", section: "Oil"))
                        pdfObjects.append(PdfObject(type: "pdf", name: "MTKIT installation and user instructions - DOC18 Rev05 - September 2005", parent: "Current", group: "Timers Programmers", section: "Oil"))
                    // Archive
                    pdfObjects.append(PdfObject(type: "dir", name: "Archive", parent: "Timers Programmers", group: nil, section: "Oil"))
                        pdfObjects.append(PdfObject(type: "pdf", name: "EPKIT installation and user instructions - DOC19 Rev03 - January 2009", parent: "Archive", group: "Timers Programmers", section: "Oil"))
                        pdfObjects.append(PdfObject(type: "pdf", name: "EPKIT installation and user instructions - Rev02 - October 2002", parent: "Archive", group: "Timers Programmers", section: "Oil"))
                        pdfObjects.append(PdfObject(type: "pdf", name: "ESKIT installation and user instructions - July 2009", parent: "Archive", group: "Timers Programmers", section: "Oil"))
                        pdfObjects.append(PdfObject(type: "pdf", name: "ETKIT installation and user instructions - DOC17 Rev04 - September 2005", parent: "Archive", group: "Timers Programmers", section: "Oil"))
                        pdfObjects.append(PdfObject(type: "pdf", name: "RFTKIT installation and user instructions - DOC20 Rev07 - March 10", parent: "Archive", group: "Timers Programmers", section: "Oil"))
                        pdfObjects.append(PdfObject(type: "pdf", name: "RFTKIT installation and user instructions - DOC20 Rev08 - April 2010", parent: "Archive", group: "Timers Programmers", section: "Oil"))
                        pdfObjects.append(PdfObject(type: "pdf", name: "RSKIT  installation and user instructions - February 2009", parent: "Archive", group: "Timers Programmers", section: "Oil"))
                        pdfObjects.append(PdfObject(type: "pdf", name: "ESKIT installation and user instructions - December 2010", parent: "Archive", group: "Timers Programmers", section: "Oil"))
                        pdfObjects.append(PdfObject(type: "pdf", name: "ETKIT installation and user instructions - DOC17 Rev06 - October 2012", parent: "Archive", group: "Timers Programmers", section: "Oil"))
                        pdfObjects.append(PdfObject(type: "pdf", name: "RFTKIT installation and user instructions - DOC20 Rev09 - July 2012", parent: "Archive", group: "Timers Programmers", section: "Oil"))
                        pdfObjects.append(PdfObject(type: "pdf", name: "RSKIT installation and user instructions - December 2010", parent: "Archive", group: "Timers Programmers", section: "Oil"))
                        pdfObjects.append(PdfObject(type: "pdf", name: "TCRKIT installation and user instructions - June 2011", parent: "Archive", group: "Timers Programmers", section: "Oil"))

    
            // Boilers
            pdfObjects.append(PdfObject(type: "dir", name: "Boilers", parent: "Oil", group: nil, section: "Oil"))
                // Current
                pdfObjects.append(PdfObject(type: "dir", name: "Current", parent: "Boilers", group: nil, section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant VortexBlue supplementary instructions - DOC 0108 - Rev 2.1 - November 2016", parent: "Current", group: "Boilers", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Vortex Eco External Floor Standing installation and servicing manual - DOC81 Rev02 - November 2008", parent: "Current", group: "Boilers", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Vortex Eco External Wall Hung installation and servicing manual - DOC83 Rev01 - November 2008", parent: "Current", group: "Boilers", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Vortex Eco Internal Floor Standing installation and servicing manual - DOC80 Rev01 - October 2008", parent: "Current", group: "Boilers", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Vortex Eco Internal Wall Hung installation and servicing manual - DOC82 Rev01 - November 2008", parent: "Current", group: "Boilers", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Vortex Pro and Eco Outdoor boiler addendum - DOC52 Rev00 - November 2012", parent: "Current", group: "Boilers", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Vortex Pro External Combi addendum - DOC89-00-01 Rev02 - November 2014", parent: "Current", group: "Boilers", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Vortex Pro External Combi installation and servicing instructions - DOC89 Rev00 - May 2012", parent: "Current", group: "Boilers", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Vortex Pro External installation and servicing instructions - DOC52 Rev06 - May 2012", parent: "Current", group: "Boilers", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Vortex Pro Internal Combi addendum - DOC88-00-01 Rev03 - January 2015", parent: "Current", group: "Boilers", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Vortex Pro Internal Combi installation and servicing instructions - DOC88 Rev00 - May 2012", parent: "Current", group: "Boilers", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Vortex Pro Kitchen Utility, System and Boiler House installation and servicing instructions - DOC37 Rev19 - May 2012", parent: "Current", group: "Boilers", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "DEFRA Water hardness map", parent: "Current", group: "Boilers", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Boiler Handbook - April 2013", parent: "Current", group: "Boilers", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Low pressure switch (MPCBS62 internal boiler) - DOC70 Rev03 - August 2010", parent: "Current", group: "Boilers", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Low pressure switch (MPCBS63 external boiler) - DOC71 Rev03 - August 2010", parent: "Current", group: "Boilers", section: "Oil"))

                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Vortex HE pump addendum  - DOC101 Rev01 - April 2015", parent: "Current", group: "Boilers", section: "Oil"))

        
                // Condensing Archive
                pdfObjects.append(PdfObject(type: "dir", name: "Condensing Archive", parent: "Boilers", group: nil, section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Vortex Eco Internal Wall Hung user guide - September 2008", parent: "Condensing Archive", group: "Boilers", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Combi 70 V3, Combi 90 V3, Combi Max, Vortex Combi 26 and 36 - DOC56 Rev02 - August 2005", parent: "Condensing Archive", group: "Boilers", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Combi 70 V3, Combi 90 V3, Combi Max, Vortex Combi 26 and 36 - DOC56 Rev03 - September 2005", parent: "Condensing Archive", group: "Boilers", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Outdoor Combi 90 V3, Combi Max and Outdoor Vortex Combi 26 and 36 manual - DOC58 Rev01 - March 2006", parent: "Condensing Archive", group: "Boilers", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Vortex 1521 Utility and Outdoor, Combi 21 and Outdoor Combi 21 supplement - DOC38 Rev02 - January 2007", parent: "Condensing Archive", group: "Boilers", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Vortex Eco External DOC81rev00 - September 2008", parent: "Condensing Archive", group: "Boilers", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Vortex Eco External provisional installation and servicing manual - DOC79 Rev00 - September 2008", parent: "Condensing Archive", group: "Boilers", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Vortex Eco External Wall Hung installation and servicing manual - DOC83 Rev00 - September 2008", parent: "Condensing Archive", group: "Boilers", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Vortex Eco Internal Wall Hung installation and servicing manual - DOC82 Rev00 - September 2008", parent: "Condensing Archive", group: "Boilers", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Vortex Eco Utility models Doc80 - August 2008", parent: "Condensing Archive", group: "Boilers", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Vortex External Module 1521 sealed system instructions - December 2006", parent: "Condensing Archive", group: "Boilers", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Vortex Kitchen Utility and system models  DOC37  rev13 - October 2006", parent: "Condensing Archive", group: "Boilers", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Vortex Kitchen Utility and system models DOC37 rev07 - December 2004", parent: "Condensing Archive", group: "Boilers", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Vortex Kitchen, Kitchen System, Utility and Utility Systems - DOC37 Rev06 - September 2004", parent: "Condensing Archive", group: "Boilers", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Vortex Kitchen, Kitchen System, Utility and Utility Systems - DOC37 Rev07 - December 2004", parent: "Condensing Archive", group: "Boilers", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Vortex Kitchen, Kitchen System, Utility and Utility Systems - DOC37 Rev08 - September 2005", parent: "Condensing Archive", group: "Boilers", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Vortex Kitchen, Kitchen System, Utility and Utility Systems - DOC37 Rev12 - September 2006", parent: "Condensing Archive", group: "Boilers", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Vortex Outdoor Modules installation and servicing manual - DOC52 Rev00 - October 2004", parent: "Condensing Archive", group: "Boilers", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Vortex PRO Combi 21e, 26e and 36e - supplement - DOC28 Rev01 - July 2008", parent: "Condensing Archive", group: "Boilers", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Vortex Pro External Combi 21e, 26e and 36e supplement DOC29 Rev01 - July 2008", parent: "Condensing Archive", group: "Boilers", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Vortex Pro External DOC52 - August 2008", parent: "Condensing Archive", group: "Boilers", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Vortex Pro External installation and servicing instructions - DOC52 Rev02 - October 2008", parent: "Condensing Archive", group: "Boilers", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Vortex Pro External installation and servicing instructions - DOC52 Rev05 - April 2012", parent: "Condensing Archive", group: "Boilers", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Vortex Pro Kitchen Utility doc37 - August 2008", parent: "Condensing Archive", group: "Boilers", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Vortex Pro Kitchen Utility installation and servicing instructions - DOC37 Rev15 - October 2008", parent: "Condensing Archive", group: "Boilers", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Vortex Pro Kitchen Utility, System and Boiler House Manual - DOC37 Rev17 - April 2012", parent: "Condensing Archive", group: "Boilers", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Vortex Eco External Wall Hung user guide September 2008", parent: "Condensing Archive", group: "Boilers", section: "Oil"))

                // Standard Efficiency Archive
                pdfObjects.append(PdfObject(type: "dir", name: "Standard Efficiency Archive", parent: "Boilers", group: nil, section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Comb90 v3 Max REV01 - November 2004", parent: "Standard Efficiency Archive", group: "Boilers", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Combi 70 and 90 installation and servicing manual - DOC10 Rev07 - June 2002", parent: "Standard Efficiency Archive", group: "Boilers", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Combi 70 and 90 installation and servicing manual rev09 - July 2003", parent: "Standard Efficiency Archive", group: "Boilers", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Combi 70 and 90 MKII installation and servicing manual - DOC10 Rev10 - October 2003", parent: "Standard Efficiency Archive", group: "Boilers", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Combi 70 V3, Combi 90 V3, Combi Max, Vortex Combi 26 and 36 - DOC56 Rev02 - August 2005", parent: "Standard Efficiency Archive", group: "Boilers", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Combi 70 V3, Combi 90 V3, Combi Max, Vortex Combi 26 and 36 - DOC56 Rev03 - September 2005", parent: "Standard Efficiency Archive", group: "Boilers", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Euroflame installation and servicing manual - DOC01 Rev15 - February 2004", parent: "Standard Efficiency Archive", group: "Boilers", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Euroflame Kitchen Utility and Boiler house manual rev11 - January 2003", parent: "Standard Efficiency Archive", group: "Boilers", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Euroflame SE models - Installation and Servicing Instructions 2003", parent: "Standard Efficiency Archive", group: "Boilers", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Multipass kitchen and boiler house manual - DOC02 Rev11 - January 2004", parent: "Standard Efficiency Archive", group: "Boilers", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Multipass kitchen and boiler house manual - DOC02 Rev12 - October 2004", parent: "Standard Efficiency Archive", group: "Boilers", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Multipass Sealed System boiler supplementary instructions - DOC26 Rev04 - January 2003", parent: "Standard Efficiency Archive", group: "Boilers", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Multipass Sealed System Kit fitting instructions - DOC12 Rev04 - January 2003", parent: "Standard Efficiency Archive", group: "Boilers", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Oil Fired Range Brochure - March 2006", parent: "Standard Efficiency Archive", group: "Boilers", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Outdoor Combi 90 MKII installation and servicing manual - DOC25 Rev09 - November 2004", parent: "Standard Efficiency Archive", group: "Boilers", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Outdoor Combi 90 V3, Combi Max and Outdoor Vortex Combi 26 and 36 manual - DOC58 Rev01 - March 2006", parent: "Standard Efficiency Archive", group: "Boilers", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Outdoor modules installation and servicing manual - DOC16 Rev06 - October 2002", parent: "Standard Efficiency Archive", group: "Boilers", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Outdoor modules installation and servicing manual - DOC16 Rev08 - August 2004", parent: "Standard Efficiency Archive", group: "Boilers", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Outdoor modules installation and servicing manual - DOC16 Rev09 - December 2004", parent: "Standard Efficiency Archive", group: "Boilers", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Swimming Pool Boiler - DOC35 Rev00 - February 2002", parent: "Standard Efficiency Archive", group: "Boilers", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Triple Pass Back Boiler DOC50 Rev01", parent: "Standard Efficiency Archive", group: "Boilers", section: "Oil"))
        
        
            // Flues
            pdfObjects.append(PdfObject(type: "dir", name: "Flues", parent: "Oil", group: nil, section: "Oil"))

                // Current
                pdfObjects.append(PdfObject(type: "dir", name: "Current", parent: "Flues", group: nil, section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant EZ-Fit Flue Guide (Oil Range) - October 2016", parent: "Current", group: "Flues", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Orange Flue System - DOC55 Rev05 - October 2006", parent: "Current", group: "Flues", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Red Flue System - DOC33 Rev01 - March 2008", parent: "Current", group: "Flues", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Red Flue System addendum - DOC33-01 Rev01 - July 2013", parent: "Current", group: "Flues", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant White System Extended Vertical Terminal - DOC91 Rev00 - September 2009", parent: "Current", group: "Flues", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant White System High Level Balanced Flue Kit - DOC32 Rev04 - October 2008", parent: "Current", group: "Flues", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant White System Vertical Balanced Flue Kit - DOC30 Rev04 - October 2008", parent: "Current", group: "Flues", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Yellow and Green Flue System - DOC54 Rev00 - September 2004", parent: "Current", group: "Flues", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Yellow Flue System - DOC51 Rev00 - July 2003", parent: "Current", group: "Flues", section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Yellow System Plume Diverter Kit - DOC90 Rev00 - September 2009", parent: "Current", group: "Flues", section: "Oil"))

                // Archive
                pdfObjects.append(PdfObject(type: "dir", name: "Archive", parent: "Flues", group: nil, section: "Oil"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Conventional Flue System - DOC55 Rev01 - September 2004", parent: "Archive", group: "Flues", section: "Oil"))

        
        // Hybrid range
        pdfObjects.append(PdfObject(type: "dir", name: "Hybrid", parent: "/", group: nil, section: "Hybrid"))
            pdfObjects.append(PdfObject(type: "pdf", name: "Grant VortexAir Hybrid range brochure - September 2016", parent: "Hybrid", group: nil, section: "Hybrid"))
        
        
        // Biomass Range
        pdfObjects.append(PdfObject(type: "dir", name: "Biomass", parent: "/", group: nil, section: "Biomass"))

                // Boilers
            pdfObjects.append(PdfObject(type: "dir", name: "Boilers", parent: "Biomass", group: nil, section: "Biomass"))
                // Current
                pdfObjects.append(PdfObject(type: "dir", name: "Current", parent: "Boilers", group: nil, section: "Biomass"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "DEFRA Water hardness map", parent: "Current", group: "Boilers", section: "Biomass"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Spira User Instructions - DOC45 Rev00 - October 2014", parent: "Current", group: "Boilers", section: "Biomass"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Spira Wood Pellet Boiler Commissioning Form - November 2014", parent: "Current", group: "Boilers", section: "Biomass"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Spira Wood Pellet Boiler installation and servicing instructions - DOC42 Rev01 - May 2013", parent: "Current", group: "Boilers", section: "Biomass"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Spira Wood Pellet Boiler installation and servicing instructions addendum - DOC42-01-02 Rev03 - December 2014", parent: "Current", group: "Boilers", section: "Biomass"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Spira Wood Pellet Boiler quick guide - DOC44 Rev04 - March 2013", parent: "Current", group: "Boilers", section: "Biomass"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant SpiraPod data sheet - February 2015", parent: "Current", group: "Boilers", section: "Biomass"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Living With Biomass Guide - October 2014", parent: "Current", group: "Boilers", section: "Biomass"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "RHI emissions certificate - December 2013", parent: "Current", group: "Boilers", section: "Biomass"))
        
                // Archive
                pdfObjects.append(PdfObject(type: "dir", name: "Archive", parent: "Boilers", group: nil, section: "Biomass"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Spira Wood Pellet Boiler installation and servicing instructions addendum - DOC42-01-01 Rev00 - February 2014", parent: "Archive", group: "Boilers", section: "Biomass"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Spira Wood Pellet Boiler installation and servicing instructions addendum - DOC42-01-02 Rev02 - October 2014", parent: "Archive", group: "Boilers", section: "Biomass"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Wood Pellet Boiler manual - Rev04 - November 2011", parent: "Archive", group: "Boilers", section: "Biomass"))
        
        
            // Accessories
            pdfObjects.append(PdfObject(type: "dir", name: "Accessories", parent: "Biomass", group: nil, section: "Biomass"))
                // Mag One
                pdfObjects.append(PdfObject(type: "dir", name: "Mag One", parent: "Accessories", group: nil, section: "Biomass"))
                    // Current
                    pdfObjects.append(PdfObject(type: "dir", name: "Current", parent: "Mag One", group: nil, section: "Biomass"))
                        pdfObjects.append(PdfObject(type: "pdf", name: "Grant UK MagOne data sheet - August 2015", parent: "Current", group: "Mag One", section: "Biomass"))
                        pdfObjects.append(PdfObject(type: "pdf", name: "Grant UK Vortex Mag-One Magnetic Filter Installation and Servicing manual - DOC98 Rev 1-1 - October 2015", parent: "Current", group: "Mag One", section: "Biomass"))

                    // Archive
                    pdfObjects.append(PdfObject(type: "dir", name: "Archive", parent: "Mag One", group: nil, section: "Biomass"))
                        pdfObjects.append(PdfObject(type: "pdf", name: "Grant Mag-One Magnetic Filter manual - DOC98 Rev00 - September 2014", parent: "Archive", group: "Mag One", section: "Biomass"))
                        pdfObjects.append(PdfObject(type: "pdf", name: "Grant Mag One Magnetic Filter Installation and Servicing manual - DOC98 Rev01 - December 2014", parent: "Archive", group: "Mag One", section: "Biomass"))
                        pdfObjects.append(PdfObject(type: "pdf", name: "Grant UK Vortex Mag-One Magnetic Filter - DOC98 Rev 1-0 - August 2015", parent: "Archive", group: "Mag One", section: "Biomass"))

        
                // Pellet Stores
                pdfObjects.append(PdfObject(type: "dir", name: "Pellet Stores", parent: "Accessories", group: nil, section: "Biomass"))
                    // Current
                    pdfObjects.append(PdfObject(type: "dir", name: "Current", parent: "Pellet Stores", group: nil, section: "Biomass"))
                        pdfObjects.append(PdfObject(type: "pdf", name: "ENplus Pellets Handbook 2.0 - August 2014", parent: "Current", group: "Pellet Stores", section: "Biomass"))
                        pdfObjects.append(PdfObject(type: "pdf", name: "Grant Pellet Stores Installation and Sevicing Instructions - DOC99 Rev00 - October 2014", parent: "Current", group: "Pellet Stores", section: "Biomass"))
                        
                    // Archive
                    pdfObjects.append(PdfObject(type: "dir", name: "Archive", parent: "Pellet Stores", group: nil, section: "Biomass"))
                        pdfObjects.append(PdfObject(type: "pdf", name: "Grant pellet store  6 tonne manual - July 2006", parent: "Archive", group: "Pellet Stores", section: "Biomass"))
                        pdfObjects.append(PdfObject(type: "pdf", name: "Grant Pellet Store 5 tonne manual - Janurary 2012", parent: "Archive", group: "Pellet Stores", section: "Biomass"))

        
                // Vacuum Systems
                pdfObjects.append(PdfObject(type: "dir", name: "Vacuum Systems", parent: "Accessories", group: nil, section: "Biomass"))
                    // Current
                    pdfObjects.append(PdfObject(type: "dir", name: "Current", parent: "Vacuum Systems", group: nil, section: "Biomass"))
                        pdfObjects.append(PdfObject(type: "pdf", name: "Grant SpiraVAC installation and user instructions (provisional) DOC43 Rev01 - February 2013", parent: "Current", group: "Vacuum Systems", section: "Biomass"))
        
                    // Archive
                    pdfObjects.append(PdfObject(type: "dir", name: "Archive", parent: "Vacuum Systems", group: nil, section: "Biomass"))
        
        
        // Heat Pump
        pdfObjects.append(PdfObject(type: "dir", name: "Heat Pump", parent: "/", group: nil, section: "Heat Pump"))
            // Accessories
            pdfObjects.append(PdfObject(type: "dir", name: "Accessories", parent: "Heat Pump", group: nil, section: "Heat Pump"))
                // Mag One
                pdfObjects.append(PdfObject(type: "dir", name: "Mag One", parent: "Accessories", group: nil, section: "Heat Pump"))
                    // Current
                    pdfObjects.append(PdfObject(type: "dir", name: "Current", parent: "Mag One", group: nil, section: "Heat Pump"))
                        pdfObjects.append(PdfObject(type: "pdf", name: "Grant UK MagOne data sheet - August 2015", parent: "Current", group: "Mag One", section: "Heat Pump"))
                        pdfObjects.append(PdfObject(type: "pdf", name: "Grant UK Vortex Mag-One Magnetic Filter Installation and Servicing manual - DOC98 Rev 1-1 - October 2015", parent: "Current", group: "Mag One", section: "Heat Pump"))


                    // Archive
                    pdfObjects.append(PdfObject(type: "dir", name: "Archive", parent: "Mag One", group: nil, section: "Heat Pump"))
                        pdfObjects.append(PdfObject(type: "pdf", name: "Grant Mag-One Magnetic Filter manual - DOC98 Rev00 - September 2014", parent: "Archive", group: "Mag One", section: "Heat Pump"))
                        pdfObjects.append(PdfObject(type: "pdf", name: "Grant Mag One Magnetic Filter Installation and Servicing manual - DOC98 Rev01 - December 2014", parent: "Archive", group: "Mag One", section: "Heat Pump"))
                        pdfObjects.append(PdfObject(type: "pdf", name: "Grant UK Vortex Mag-One Magnetic Filter - DOC98 Rev 1-0 - August 2015", parent: "Archive", group: "Mag One", section: "Heat Pump"))

        
            // Air Source Heat Pumps
            pdfObjects.append(PdfObject(type: "dir", name: "Air Source Heat Pumps", parent: "Heat Pump", group: nil, section: "Heat Pump"))
                // Current
                pdfObjects.append(PdfObject(type: "dir", name: "Current", parent: "Air Source Heat Pumps", group: nil, section: "Heat Pump"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant UK Aerona3 installation and servicing instructions - DOC 0109 - Rev 1.1 - May 2016", parent: "Current", group: "Air Source Heat Pumps", section: "Heat Pump"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant UK Addendum to Aerona3 Installation Instructions DOC 0109-1.1-01 Rev 00 - August 2016", parent: "Current", group: "Air Source Heat Pumps", section: "Heat Pump"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant HPDHWBK1 Domestic Hot Water Kit Instructions - February 2011", parent: "Current", group: "Air Source Heat Pumps", section: "Heat Pump"))
        
                // Archive
                pdfObjects.append(PdfObject(type: "dir", name: "Archive", parent: "Air Source Heat Pumps", group: nil, section: "Heat Pump"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Air Source Heat Pump manual - DOC87 Rev00 - January 2010", parent: "Archive", group: "Air Source Heat Pumps", section: "Heat Pump"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Air Source Heat Pump manual - DOC87 Rev03 - November 2010", parent: "Archive", group: "Air Source Heat Pumps", section: "Heat Pump"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Air Source Heat Pump manual - DOC87 Rev04 - November 2010", parent: "Archive", group: "Air Source Heat Pumps", section: "Heat Pump"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Air Source Heat Pump User handbook - April 2011", parent: "Archive", group: "Air Source Heat Pumps", section: "Heat Pump"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant SE Air Source Heat Pump manual addendum - DOC87 Rev02 - January 2013", parent: "Archive", group: "Air Source Heat Pumps", section: "Heat Pump"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant SE Air Source Heat Pump manual addendum - DOC87 Rev04 - March 2013", parent: "Archive", group: "Air Source Heat Pumps", section: "Heat Pump"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant SE Air Source Heat Pump manual addendum - DOC87 Rev05 - March 2014", parent: "Archive", group: "Air Source Heat Pumps", section: "Heat Pump"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Aerona ASHE Air Source Heat Pump manual (provisional) - DOC93 Rev00 - April 2013", parent: "Archive", group: "Air Source Heat Pumps", section: "Heat Pump"))

        
        // Solar Thermal
        pdfObjects.append(PdfObject(type: "dir", name: "Solar Thermal", parent: "/", group: nil, section: "Solar Thermal"))
            // Controller
            pdfObjects.append(PdfObject(type: "dir", name: "Controller", parent: "Solar Thermal", group: nil, section: "Solar Thermal"))
                // Current
                pdfObjects.append(PdfObject(type: "dir", name: "Current", parent: "Controller", group: nil, section: "Solar Thermal"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant UK GSX1 Solar Controller (GS222765) manual - DOC97 Rev00 - November 2013", parent: "Current", group: "Controller", section: "Solar Thermal"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant UK GSX1 Solar Controller (GS222765) manual addendum - DOC97ADD Rev00 - November 2013", parent: "Current", group: "Controller", section: "Solar Thermal"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant UK SD3X Solar Controller (east west systems) - DOC 0107 - Rev 1.0 - November 2015", parent: "Current", group: "Controller", section: "Solar Thermal"))
        
        
                // Archive
                pdfObjects.append(PdfObject(type: "dir", name: "Archive", parent: "Controller", group: nil, section: "Solar Thermal"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant 306 Installation and Operating Instructions - March 2009", parent: "Archive", group: "Controller", section: "Solar Thermal"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant GSD1 Solar Controller (GS222763) manual - DOC94 Rev01 - November 2012", parent: "Archive", group: "Controller", section: "Solar Thermal"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant GSD1 Solar Controller (GS222763) password reset - DOC94-01 Rev00 - November 2012", parent: "Archive", group: "Controller", section: "Solar Thermal"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant GSD3 Solar Controller (GS222020) - DOC95 Rev00 - October 2011", parent: "Archive", group: "Controller", section: "Solar Thermal"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant SD2-PT solar controller operating instructions - June 2010", parent: "Archive", group: "Controller", section: "Solar Thermal"))
        
        
            // Grant Solar Systems
            pdfObjects.append(PdfObject(type: "dir", name: "Grant Solar Systems", parent: "Solar Thermal", group: nil, section: "Solar Thermal"))
                // Current
                pdfObjects.append(PdfObject(type: "dir", name: "Current", parent: "Grant Solar Systems", group: nil, section: "Solar Thermal"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant 2 and 3 way solar valve instructions (GS222014A and GS2220015A) August 2012", parent: "Current", group: "Grant Solar Systems", section: "Solar Thermal"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant CombiSol manual - DOC76 Rev01 - September 2010", parent: "Current", group: "Grant Solar Systems", section: "Solar Thermal"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Solar fluid data sheet - April 2014", parent: "Current", group: "Grant Solar Systems", section: "Solar Thermal"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Solar Fluid Recovery Container - June 2015", parent: "Current", group: "Grant Solar Systems", section: "Solar Thermal"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Solar Thermal manual - DOC73 Rev04 - April 2013", parent: "Current", group: "Grant Solar Systems", section: "Solar Thermal"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant WinterSol manual - January 2015", parent: "Current", group: "Grant Solar Systems", section: "Solar Thermal"))
        
                // Archive
                pdfObjects.append(PdfObject(type: "dir", name: "Archive", parent: "Grant Solar Systems", group: nil, section: "Solar Thermal"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant CombiSOL Installation Manual - April 2008", parent: "Archive", group: "Grant Solar Systems", section: "Solar Thermal"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Solar PV Manual - DOC86 Rev01 - August 2010", parent: "Archive", group: "Grant Solar Systems", section: "Solar Thermal"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Solar Thermal Installation and User Guide - July 2006", parent: "Archive", group: "Grant Solar Systems", section: "Solar Thermal"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Solar Thermal manual - August 2006", parent: "Archive", group: "Grant Solar Systems", section: "Solar Thermal"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Solar Thermal manual - DOC73 Rev02 - June 2010", parent: "Archive", group: "Grant Solar Systems", section: "Solar Thermal"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Solar Thermal Manual - November 2008", parent: "Archive", group: "Grant Solar Systems", section: "Solar Thermal"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Solar Thermal manual addendum - DOC73 Rev00 - February 2014", parent: "Archive", group: "Grant Solar Systems", section: "Solar Thermal"))

        
            // Pump Stations
            pdfObjects.append(PdfObject(type: "dir", name: "Pump Stations", parent: "Solar Thermal", group: nil, section: "Solar Thermal"))
                // Current
                pdfObjects.append(PdfObject(type: "dir", name: "Current", parent: "Pump Stations", group: nil, section: "Solar Thermal"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Solar pump station addendum - DOC96-05-01 Rev01 - April 2015", parent: "Current", group: "Pump Stations", section: "Solar Thermal"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Solar Pump Station manual - DOC96 Rev04 - March 2014", parent: "Current", group: "Pump Stations", section: "Solar Thermal"))
        
                // Archive
                pdfObjects.append(PdfObject(type: "dir", name: "Archive", parent: "Pump Stations", group: nil, section: "Solar Thermal"))
        
      
        
        // Cylinder Range
        pdfObjects.append(PdfObject(type: "dir", name: "Cylinder", parent: "/", group: nil, section: "Cylinder"))
            // hot water cylinders
            pdfObjects.append(PdfObject(type: "dir", name: "Hot Water Cylinders", parent: "Cylinder", group: nil, section: "Cylinder"))
                // Current
                pdfObjects.append(PdfObject(type: "dir", name: "Current", parent: "Hot Water Cylinders", group: nil, section: "Cylinder"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant MonoWave 'A' rated cylinder data sheet - August 2016", parent: "Current", group: "Hot Water Cylinders", section: "Cylinder"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Cylinder Benchmark book", parent: "Current", group: "Hot Water Cylinders", section: "Cylinder"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant DuoWave Cylinder addendum manual - DOC75Add Rev01 - September 2013", parent: "Current", group: "Hot Water Cylinders", section: "Cylinder"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant DuoWave Cylinder manual - DOC75 Rev06 - January 2011", parent: "Current", group: "Hot Water Cylinders", section: "Cylinder"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Duowave Plus Cylinder addendum manual - DOC77Add - Rev01 - September 2013", parent: "Current", group: "Hot Water Cylinders", section: "Cylinder"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Duowave Plus Cylinder manual - DOC77 - Rev03 - January 2011", parent: "Current", group: "Hot Water Cylinders", section: "Cylinder"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant MonoWave Cylinder addendum manual - DOC74Add Rev01 - September 2013", parent: "Current", group: "Hot Water Cylinders", section: "Cylinder"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant MonoWave Cylinder manual - DOC74 Rev05 - July 2011", parent: "Current", group: "Hot Water Cylinders", section: "Cylinder"))
                    
        
                // Archive
                pdfObjects.append(PdfObject(type: "dir", name: "Archive", parent: "Hot Water Cylinders", group: nil, section: "Cylinder"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Duowave Cylinder Manual - DOC75 Rev02 - May 2009", parent: "Archive", group: "Hot Water Cylinders", section: "Cylinder"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant DuoWave Cylinder manual - DOC75 Rev05 - December 2010", parent: "Archive", group: "Hot Water Cylinders", section: "Cylinder"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant DuoWave Cylinder manual - DOC75 Rev05 - November 2010", parent: "Archive", group: "Hot Water Cylinders", section: "Cylinder"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Duowave Plus Cylinder manual - DOC77 - Rev02 - December 2010", parent: "Archive", group: "Hot Water Cylinders", section: "Cylinder"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Duowave Plus Cylinder manual - DOC77 Rev01 - November 2010", parent: "Archive", group: "Hot Water Cylinders", section: "Cylinder"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant DuowavePlus Cylinder - DOC77 Rev00 - June 2009", parent: "Archive", group: "Hot Water Cylinders", section: "Cylinder"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Monowave Cylinder Manual - DOC74 Rev00 - May 2009", parent: "Archive", group: "Hot Water Cylinders", section: "Cylinder"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant MonoWave Cylinder manual - DOC74 Rev01 - November 2010", parent: "Archive", group: "Hot Water Cylinders", section: "Cylinder"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant MonoWave Cylinder manual - DOC74 Rev02  - December 2010", parent: "Archive", group: "Hot Water Cylinders", section: "Cylinder"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant MonoWave Cylinder manual - DOC74 Rev03  - December 2010", parent: "Archive", group: "Hot Water Cylinders", section: "Cylinder"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant MonoWave Cylinder manual - DOC74 Rev04 - January 2011", parent: "Archive", group: "Hot Water Cylinders", section: "Cylinder"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Wave Cylinder Technical Manual V1 - May 2007", parent: "Archive", group: "Hot Water Cylinders", section: "Cylinder"))

            // Thermal Store
            pdfObjects.append(PdfObject(type: "dir", name: "Thermal Store", parent: "Cylinder", group: nil, section: "Cylinder"))
                // Current
                pdfObjects.append(PdfObject(type: "dir", name: "Current", parent: "Thermal Store", group: nil, section: "Cylinder"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant ThermaWave Thermal Store manual - DOC78 Rev01 - June 2011", parent: "Current", group: "Thermal Store", section: "Cylinder"))
        
                // Archive
                pdfObjects.append(PdfObject(type: "dir", name: "Archive", parent: "Thermal Store", group: nil, section: "Cylinder"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant ThermaWave manual (temporary version) - May 2009", parent: "Archive", group: "Thermal Store", section: "Cylinder"))
        
        // Controls Range
        pdfObjects.append(PdfObject(type: "dir", name: "Controls", parent: "/", group: nil, section: "Controls"))
 
            // Low Loss Headers
            pdfObjects.append(PdfObject(type: "dir", name: "Low Loss Headers", parent: "Controls", group: nil, section: "Controls"))

                // Current
                pdfObjects.append(PdfObject(type: "dir", name: "Current", parent: "Low Loss Headers", group: nil, section: "Controls"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant low loss header system (70kW) installation and user instructions - DOC66 Rev05 - October 2013", parent: "Current", group: "Low Loss Headers", section: "Controls"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant low loss header system (165kW) installation and user instructions - DOC67 Rev05 - October 2013", parent: "Current", group: "Low Loss Headers", section: "Controls"))

                // Archive
                pdfObjects.append(PdfObject(type: "dir", name: "Archive", parent: "Low Loss Headers", group: nil, section: "Controls"))
        
        
            // Other Timers Programmers
            pdfObjects.append(PdfObject(type: "dir", name: "Other Timers Programmers", parent: "Controls", group: nil, section: "Controls"))
        
                // Current
                pdfObjects.append(PdfObject(type: "dir", name: "Current", parent: "Other Timers Programmers", group: nil, section: "Controls"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "RSKIT installation and user instructions - December 2010", parent: "Current", group: "Other Timers Programmers", section: "Controls"))
        
                // Archive
                pdfObjects.append(PdfObject(type: "dir", name: "Archive", parent: "Other Timers Programmers", group: nil, section: "Controls"))
        

            // Sequence Controllers
            pdfObjects.append(PdfObject(type: "dir", name: "Sequence Controllers", parent: "Controls", group: nil, section: "Controls"))
                // Current
                pdfObjects.append(PdfObject(type: "dir", name: "Current", parent: "Sequence Controllers", group: nil, section: "Controls"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant GES264 Data Brochure - March 2013", parent: "Current", group: "Sequence Controllers", section: "Controls"))
        
                // Archive
                pdfObjects.append(PdfObject(type: "dir", name: "Archive", parent: "Sequence Controllers", group: nil, section: "Controls"))

        
            // Weather Compensation Controls
            pdfObjects.append(PdfObject(type: "dir", name: "Weather Compensation Controls", parent: "Controls", group: nil, section: "Controls"))
        
                // Current
                pdfObjects.append(PdfObject(type: "dir", name: "Current", parent: "Weather Compensation Controls", group: nil, section: "Controls"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant GEO360 5 Zone DHW Diagram - August 2008", parent: "Current", group: "Weather Compensation Controls", section: "Controls"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant GEO360 Installation and User instructions - December 2010", parent: "Current", group: "Weather Compensation Controls", section: "Controls"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant GEO360 Multiple Zone + Cylinder S Plan schematic - August 2011", parent: "Current", group: "Weather Compensation Controls", section: "Controls"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant GEO360 Wiring Diagram - August 2011", parent: "Current", group: "Weather Compensation Controls", section: "Controls"))

        
                // Archive
                pdfObjects.append(PdfObject(type: "dir", name: "Archive", parent: "Weather Compensation Controls", group: nil, section: "Controls"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Efficiency Optimiser Brochure - October 2006", parent: "Archive", group: "Weather Compensation Controls", section: "Controls"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Efficiency Optimiser Instructions - October 2006", parent: "Archive", group: "Weather Compensation Controls", section: "Controls"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Efficiency Optimiser Sensor Instructions - October 2006", parent: "Archive", group: "Weather Compensation Controls", section: "Controls"))
        
            
            // Zone Pumps
            pdfObjects.append(PdfObject(type: "dir", name: "Zone Pumps", parent: "Controls", group: nil, section: "Controls"))
                // Current
                pdfObjects.append(PdfObject(type: "dir", name: "Current", parent: "Zone Pumps", group: nil, section: "Controls"))
                    pdfObjects.append(PdfObject(type: "pdf", name: "Grant Header System Installation Instructions Rev3 - June 2013", parent: "Current", group: "Zone Pumps", section: "Controls"))
        
                // Archive
                pdfObjects.append(PdfObject(type: "dir", name: "Archive", parent: "Zone Pumps", group: nil, section: "Controls"))

    }
    
    func get(_ index: Int) -> PdfObject {
        return pdfObjects[index]
    }
    
    func getObjectForParent(_ index: Int) -> PdfObject {
        return arrayForGivenParent[index]
    }
    
    func getObjectForParentFromRoot(_ index: Int) -> PdfObject {
        return rootArray[index]
    }
    
    func getParentFromName(_ name: String) -> PdfObject{
     
        if count == 0 {
            prepop()
        }
        
        var foundPdfObject: PdfObject;
        foundPdfObject = self.get(0)
        
        for pdfObject in pdfObjects {
            if pdfObject.name == name {
                foundPdfObject = pdfObject
            }
        }
        return foundPdfObject
    }
    
}

