import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0

Item {
    function treeData() {
        const list = [];
        for (let i = 0; i < 6; i += 1) {
            const key = `Node-${i}`;
            const treeNode = {
                title: key,
                key: key,
            };
            list.push(treeNode);
        }
        return list;
    }

    FluTreeView{
        id:tree_view
        anchors.fill: parent
        cellHeight: 30
        draggable: true
        showLine: true
        checkable:false
        depthPadding: 30
        Component.onCompleted: {
            var data = treeData()
            dataSource = data
        }
        function appendRow(title) {
            var newData = { title: title, key: title };
            var currentData = tree_view.dataSource;
            currentData.push(newData);
            tree_view.dataSource = currentData;
        }
        function updateDataSource(newDataSource) {
            tree_view.dataSource = newDataSource;
        }

        function getAllTitle() {
            var allData = tree_view.getAllData();
            for (var i = 0; i < allData.length; i ++) {
                print(allData[i].title);
            }
        }
    }
    FluButton{
        onClicked: {
            var allData = tree_view.getAllData();
            var newDataArray = [];
            for (var i = 0; i < allData.length; i ++) {
                var newData = {
                    title: allData[i].title,
                    key: allData[i].key
                };
                newDataArray.push(newData);
            }
            tree_view.updateDataSource(newDataArray)
            var title = "test Node";
            tree_view.appendRow(title);
        }
    }
    FluButton{
        anchors{
            right: parent.right
        }

        onClicked: {
            tree_view.getAllTitle();
            print(tree_view.getCurrentClickedItemIndex())
        }
    }
}
