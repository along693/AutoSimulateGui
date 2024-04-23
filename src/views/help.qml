import QtQuick
import QtQuick.Pdf
import QtQuick.Controls
import FluentUI
import QtQuick.Layouts

Item {
    id: docView
    width: parent.width
    height: parent.height

    PdfDocument {
        id: doc
        source: "file:///C:/Users/long/Desktop/LanguageDescription/Description.pdf"
    }
    TreeView {
        id: bookmarksTree
        anchors{
            left: parent.left
            top: parent.top
            bottom: parent.bottom
            right: pdfView.left
        }

        width: parent.width / 4
        height: parent.height
        clip: true
        delegate: TreeViewDelegate {
            required property int page
            required property point location
            required property real zoom
            onClicked: pdfView.goToLocation(page, location, zoom)
        }
        model: PdfBookmarkModel {
            document: doc
        }
        ScrollBar.vertical: FluScrollBar { }
    }

    PdfMultiPageView {
        id: pdfView
        anchors{
            top: parent.top
            bottom: parent.bottom
            left: bookmarksTree.right
            right: parent.right
        }
        document: doc

        Keys.onPressed: (event)=> {
            if (event.key === Qt.Key_F && event.modifiers & Qt.ControlModifier) {
                searchField.forceActiveFocus();
                event.accepted = true;
            }
            if (event.key === Qt.Key_Enter) {
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
