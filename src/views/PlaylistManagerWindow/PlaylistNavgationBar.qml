import QtQuick 2.4
import DMusic 1.0
import "../DMusicWidgets"

Rectangle {

    id: playlistNavgationBar

    property var addButton: addButton
    property var starList: starList
    property var termporyList: termporyList
    property var playlistInputText: playlistInputText
    property var customPlaylistView: customPlaylistView

    property var _playlistName

    width : 120
    height: parent.height - 10
    color: "white"

    signal addPlaylistName(string name)
    signal playlistNameChanged(string name)

    Column {

        
        anchors.fill: parent

        Rectangle {
            id: fixPlaylistBar
            width: 120
            height: 64

            Column {
                spacing: 16

                StarDelegate{
                    id: starList
                }
                TermporyDelegate{
                    id: termporyList
                }
            }

        }

        Rectangle {
            id: separator
            width: 120
            height: 1
            color: "#dfdfdf"
        }

        Rectangle {
            id: playlistBox
            width: 120
            height: playlistNavgationBar.height - separator.height - fixPlaylistBar.height - 20
            color: "white"

            Rectangle {
                id: playlistTitle
                width: parent.width
                height: 42
                Rectangle {
                    anchors.fill: parent
                    anchors.topMargin: 14
                    anchors.bottomMargin: 12
                    width: parent.width
                    height: 16
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        width: 100
                        height: 11
                        color: "#b9b9b9"
                        font.pixelSize: 11
                        text: '我创建的歌单'
                    }

                    DAddButton {
                        id: addButton
                        anchors.right: parent.right
                        width: 16
                        height: 16
                    }
                }
            }

            Rectangle {
            	id: playlistInputTextBox
                width: 94
                height: 26
                anchors.left: playlistBox.left
                anchors.top: playlistTitle.bottom
                anchors.right: playlistBox.right
                border.color: "gray"
                border.width: 1
                radius: 2
                visible: false
                // color: "gray"

                TextInput  {
                	id: playlistInputText
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    color: "#868686"
                    font.pixelSize: 12
                    clip: true
                    activeFocusOnTab: true
                    activeFocusOnPress: true
                    cursorVisible: true
                    selectByMouse: true
                    selectionColor: 'green'
                    text: '1'
                    // readOnly: true
                    // maximumLength: 10
                    // wrapMode: TextInput.WordWrap
                }
            }

            ListModel {
		        id: playlistModel
		    }

            ListView {
            	id: customPlaylistView
                clip: true
                anchors.top: playlistTitle.bottom
                anchors.bottom: playlistBox.bottom
                anchors.left: playlistBox.left
                width: 120
                highlightMoveDuration: 1
                model: playlistModel
                delegate: PlaylistNameDelegate{}
                focus: true
                spacing: 14
                snapMode:ListView.SnapToItem

                // signal playMusicByUrl(string url)

                DScrollBar {
                    flickable: parent
                    inactiveColor: 'black'
                }
            }
        }
        
        Connections {
            target: addButton
            onClicked: {
            	playlistInputTextBox.visible = true;
                playlistInputText.focus = true
                playlistInputText.text = "新建歌单" + (customPlaylistView.count + 1)
            	customPlaylistView.anchors.top =  playlistInputTextBox.bottom;
                customPlaylistView.anchors.topMargin =  14;
            }
        }

        Connections {
            target: playlistInputText
            onAccepted:{
            	playlistInputTextBox.visible = false;
                playlistInputText.focus = false;
            	customPlaylistView.anchors.top =  playlistTitle.bottom;
                customPlaylistView.anchors.topMargin =  0;

                playlistNavgationBar.addPlaylistName(playlistInputText.text)

            }
        }

        Connections {
            target: starList
            onClicked: {
                termporyList.state = '!Active';
                if (customPlaylistView.currentItem){
                    customPlaylistView.currentItem.state = '!Active';
                }
                playlistNavgationBar.playlistNameChanged(starList.name);
            } 
        }

        Connections {
            target: termporyList
            onClicked: {
                starList.state = '!Active'
                if (customPlaylistView.currentItem){
                    customPlaylistView.currentItem.state = '!Active';
                }
                playlistNavgationBar.playlistNameChanged(termporyList.name);
            } 
        }

        Connections {
            target: customPlaylistView
            onCurrentIndexChanged: {
                starList.state = '!Active';
                termporyList.state = '!Active';
                var name = customPlaylistView.currentItem.playlistName
                if (name != _playlistName){
                    playlistNavgationBar.playlistNameChanged(name);
                    _playlistName = name;
                }
            } 
        }
    }
}