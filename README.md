# RCKML

A library for reading and writing KML files in Swift, designed for simplicity and ease of use.

---

### Dependencies

- [AEXML](https://github.com/tadija/AEXML) for reading and writing XML files
- [ZipFoundation](https://github.com/weichsel/ZIPFoundation) for dealing with compression for KMZ data.

---

## Index:

- [Supported KML Types](#supported-kml-types)
- [KMLDocument](#kmldocument)
- [Reading KML Files](#reading-kml-files)
- [Writing KML Files](#writing-kml-files)
- [Further To-Do's](#further-to-dos)

---

## Supported KML Types

- Feature
    - Container
        - Document
        - Folder
    - Placemark
- Geometry
    - Point
    - LineString
    - LinearRing
    - Polygon
    - Multigeometry
- StyleSelector
    - Style
    - StyleMap
- ColorStyle
    - LineStyle
    - PolyStyle
- Sub-formats
    - KML Color
    - Coordinates

>Not all types are supported with all options available to KML files. I've focused on types and features that can be used in MapKit for now.

---

## KMLDocument

The root of a KML file is represented by the `KMLDocument` struct, which is used as a container for any number of Features, and any top-level global Styles.

When creating a KMLDocument from scratch (rather than reading from an existing file), you may optionally add a name and description to the document, then add an array of included features and a dictionary of global styles.

```swift
public struct KMLDocument {
    public var name: String?
    public var featureDescription: String?
    public var features: [KMLFeature]
    public var styles: [KMLStyleUrl: KMLStyleSelector]
}
```

---

## Reading KML Files

```swift
let fileUrl = ...
let fileData = try Data(contentsOf: fileUrl)
let kmlString = try? String(contentsOf: fileUrl, encoding: .utf8)
let kmzFileUrl = ...
let kmzFileData = try Data(contentsOf: kmzFileUrl)

let documentFromData = try? KMLDocument(fileData)
let documentFromFileUrl = try? KMLDocument(fileUrl)
let documentFromString = try? KMLDocument(kmlString)
let documentFromKmzFile = try? KMLDocument(kmzFileUrl) //init(_ url:) works with either KML or KMZ files.
let documentFromKmzData = try? KMLDocument(kmzData: kmzFileData)
```

---

## Writing KML Files

```swift
let kmlDoc = KMLDocument(...)

let asData = kmlDoc.kmlData()
let asString = kmlDoc.kmlString()
let asKmzData = kmlDoc.kmzData()
```

---

## Further To-Do's

- Documentation: How to add further KML type support

---
