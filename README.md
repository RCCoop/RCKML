# RCKML

A library for reading and writing KML files in Swift. Nothing too fancy, but also not too basic.

Made for personal use, but who knows what's next!

---

### Dependencies

- [AEXML](https://github.com/tadija/AEXML) for reading and writing XML files

---

## Index:

- [Supported KML Types]()
- [KMLDocument]()
- [Reading KML Files]()
- [Writing KML Files]()
- [Further To-Do's]()

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

Not all types are supported with all options available to KML files. I've focused on types and features that can be used in MapKit for now.

---

## KMLDocument

The root of a KML file is represented by the `KMLDocument` struct, which is used as a container for any number of Features, and any top-level global Styles.

When creating a KMLDocument from scratch (rather than reading from an existing file), you may optionally add a name and description to the document, then add an array of included features and a dictionary of global styles.

```swift
public struct KMLDocument {
    public var name: String?
    public var description: String?
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

let documentFromData = try? KMLDocument(data: fileData)
let documentFromFileUrl = try? KMLDocument(url: fileUrl)
let documentFromString = try? KMLDocument(kmlString: kmlString)
```

---

## Writing KML Files

```swift
let kmlDoc = KMLDocument(...)

let asData = kmlDoc.kmlData()
let asString = kmlDoc.kmlString()
```

---

## Further To-Do's

- Handle KMZ files
- Documentation: How to add further KML type support

---
