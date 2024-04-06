import QtQuick
import QtQuick.Pdf
import QtQuick.Controls
import FluentUI

Item {
    id: docView
    width: parent.width
    height: parent.height

    PdfDocument {
        id: doc
        source: "file:///C:/Users/long/Desktop/LanguageDescription/Description.pdf"
        Component.onCompleted: {
            print(doc.author, doc.creator, doc.keywords, doc.maxPageHeight, doc.maxPageWidth, doc.status)
        }
    }

    PdfMultiPageView {
        id: pdfView
        anchors.fill: parent
        document:doc
        renderScale: 10
        Component.onCompleted: {
            pdfView.scaleToWidth(parent.width, parent.height)
        }

        Keys.onPressed: (event)=> {
            if (event.key === Qt.Key_F && event.modifiers & Qt.ControlModifier) {
                searchField.forceActiveFocus();
                event.accepted = true;
            }
            if (event.key === Qt.Key_Enter) {
                pdfView.scaleToWidth(parent.width, parent.height);
                pdfView.searchForward();
            }
        }
    }

    FluTextBox {
        id: searchField
        width: 200
        placeholderText: "Search..."
        anchors {
            top: parent.top
            right: parent.right
            topMargin: 10
            rightMargin: 20
        }

        onTextChanged: {
            pdfView.searchString = text;
        }
        onCommit: {
            pdfView.searchForward();
        }
    }
}
