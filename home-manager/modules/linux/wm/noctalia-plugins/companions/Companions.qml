import QtQuick
import qs.Commons

Item {
    id: root

    property int spriteSize: 128
    property string language: "en"
    property bool useSystemFont: false
    CompanionTheme {
        id: theme
    }

    readonly property string textFamily: root.useSystemFont ? Settings.data.ui.fontDefault : "Share Tech Mono"
    readonly property real textScale: root.useSystemFont ? Settings.data.ui.fontDefaultScale * Style.uiScaleRatio : 1.0
    readonly property int nameFontSize: Math.round((root.useSystemFont ? Style.fontSizeS : 10) * root.textScale)
    readonly property int bubbleFontSize: Math.round((root.useSystemFont ? Style.fontSizeM : 11) * root.textScale)
    readonly property int nameLetterSpacing: root.useSystemFont ? 0 : 2
    readonly property int bubbleNameLetterSpacing: root.useSystemFont ? 0 : 3

    function alpha(c, a) {
        return Qt.rgba(c.r, c.g, c.b, a);
    }

    readonly property var copy: ({
            en: {
                standard: [
                    {
                        lines: ["You type quickly. Not as quickly as an axe.", "This timer is unnecessary. Work.", "Good pace. Continue.", "My axe is more precise than your cursor."],
                        reactions: [
                            {
                                type: "angry",
                                text: "Stop clicking me."
                            },
                            {
                                type: "angry",
                                text: "THIS IS MY FINAL WARNING."
                            },
                            {
                                type: "bounce",
                                text: "...Fine. You win. I will jump."
                            }
                        ]
                    },
                    {
                        lines: ["You could type with a little more grace.", "This is not a timer. It is a dance.", "Speed without grace is just noise.", "Another session? Take care of yourself."],
                        reactions: [
                            {
                                type: "love",
                                text: "Oh... you notice me that much?"
                            },
                            {
                                type: "spin",
                                text: "Hehe~ I will spin for you!"
                            },
                            {
                                type: "love",
                                text: "...I think I have grown attached to you."
                            }
                        ]
                    },
                    {
                        lines: ["Emotions are prohibited. Still... I am watching.", "Mission in progress. Continue working.", "System operational. Anomalies: 0.", "Connection stable. Systems normal."],
                        reactions: [
                            {
                                type: "glow",
                                text: "Abnormal operator behavior detected."
                            },
                            {
                                type: "glow",
                                text: "This level of interaction exceeds normal parameters."
                            },
                            {
                                type: "glow",
                                text: "...Pod. Record this. The operator trusts me."
                            }
                        ]
                    }
                ]
            },
            pt: {
                standard: [
                    {
                        lines: ["Voce digita rapido. Nao tao rapido quanto um machado.", "Esse cronometro e desnecessario. Trabalhe.", "Bom ritmo. Continue.", "Meu machado e mais preciso que seu cursor."],
                        reactions: [
                            {
                                type: "angry",
                                text: "Pare de clicar em mim."
                            },
                            {
                                type: "angry",
                                text: "ESTE E MEU AVISO FINAL."
                            },
                            {
                                type: "bounce",
                                text: "...Tudo bem. Voce venceu. Eu vou pular."
                            }
                        ]
                    },
                    {
                        lines: ["Voce poderia digitar com um pouco mais de graca.", "Isto nao e um cronometro. E uma danca.", "Velocidade sem graca e so barulho.", "Outra sessao? Cuide-se."],
                        reactions: [
                            {
                                type: "love",
                                text: "Ah... voce me nota tanto assim?"
                            },
                            {
                                type: "spin",
                                text: "Hehe, eu vou girar para voce!"
                            },
                            {
                                type: "love",
                                text: "...Acho que me apeguei a voce."
                            }
                        ]
                    },
                    {
                        lines: ["Emocoes sao proibidas. Ainda assim... estou observando.", "Missao em andamento. Continue trabalhando.", "Sistema operacional. Anomalias: 0.", "Conexao estavel. Sistemas normais."],
                        reactions: [
                            {
                                type: "glow",
                                text: "Comportamento anormal do operador detectado."
                            },
                            {
                                type: "glow",
                                text: "Este nivel de interacao excede parametros normais."
                            },
                            {
                                type: "glow",
                                text: "...Pod. Registre isto. O operador confia em mim."
                            }
                        ]
                    }
                ]
            },
            ja: {
                standard: [
                    {
                        lines: ["入力は速い。だが斧ほどではない。", "タイマーは不要だ。作業しろ。", "いいペースだ。続けろ。", "私の斧は君のカーソルより正確だ。"],
                        reactions: [
                            {
                                type: "angry",
                                text: "クリックするな。"
                            },
                            {
                                type: "angry",
                                text: "これが最後の警告だ。"
                            },
                            {
                                type: "bounce",
                                text: "...いいだろう。君の勝ちだ。跳んでやる。"
                            }
                        ]
                    },
                    {
                        lines: ["もう少し優雅に打てるはずよ。", "これはタイマーじゃない。舞よ。", "優雅さのない速さは、ただの雑音。", "また一仕事？ 体も大事にしてね。"],
                        reactions: [
                            {
                                type: "love",
                                text: "あら...そんなに見てくれていたの？"
                            },
                            {
                                type: "spin",
                                text: "ふふ、回ってあげる！"
                            },
                            {
                                type: "love",
                                text: "...少し、情が移ったみたい。"
                            }
                        ]
                    },
                    {
                        lines: ["感情は禁止。それでも...監視している。", "任務進行中。作業を継続。", "システム正常。異常: 0。", "接続安定。各系統正常。"],
                        reactions: [
                            {
                                type: "glow",
                                text: "異常な操作者行動を検出。"
                            },
                            {
                                type: "glow",
                                text: "この接触頻度は通常値を超過。"
                            },
                            {
                                type: "glow",
                                text: "...ポッド、記録して。操作者は私を信頼している。"
                            }
                        ]
                    }
                ]
            }
        })

    readonly property string activeLanguage: root.copy[root.language] ? root.language : "en"
    readonly property var activeCopy: root.copy[root.activeLanguage].standard

    readonly property var companions: [
        {
            name: "AMAZON",
            color: theme.red,
            src: Qt.resolvedUrl("assets/amazon.gif"),
            lines: root.activeCopy[0].lines,
            reactions: root.activeCopy[0].reactions
        },
        {
            name: "MAI SHIRANUI",
            color: theme.gold,
            src: Qt.resolvedUrl("assets/mai.gif"),
            lines: root.activeCopy[1].lines,
            reactions: root.activeCopy[1].reactions
        },
        {
            name: "2B // YoRHa",
            color: theme.fg,
            src: Qt.resolvedUrl("assets/2b.gif"),
            lines: root.activeCopy[2].lines,
            reactions: root.activeCopy[2].reactions
        }
    ]

    property int currentIdx: 2
    property var lineIdxs: [0, 0, 0]
    property var reactUsed: [[], [], []]
    property var clickTimes: [[], [], []]
    property var reactCooldown: [0, 0, 0]
    property bool isReacting: false
    property bool bubbleVisible: false
    property bool isReactionBubble: false
    property string bubbleText: ""

    readonly property int spamCount: 7
    readonly property int spamWindow: 1200
    readonly property int reactCooldownMs: 4000

    onLanguageChanged: resetDialogue()

    implicitWidth: 26 + root.spriteSize + 26 + 6
    implicitHeight: outerCol.implicitHeight

    Column {
        id: outerCol
        width: root.implicitWidth
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        spacing: 4

        Rectangle {
            width: parent.width
            height: 96
            color: alpha(theme.bg, 0.97)
            border.color: root.isReactionBubble ? theme.gold : alpha(theme.fg, 0.22)
            border.width: 1
            visible: root.bubbleVisible
            opacity: root.bubbleVisible ? 1 : 0
            clip: true
            Behavior on opacity {
                NumberAnimation {
                    duration: 200
                }
            }

            Column {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: 8
                spacing: 3

                Text {
                    width: parent.width
                    text: root.companions[root.currentIdx].name
                    font.family: root.textFamily
                    font.pixelSize: root.nameFontSize
                    font.letterSpacing: root.bubbleNameLetterSpacing
                    color: root.companions[root.currentIdx].color
                    elide: Text.ElideRight
                }

                Text {
                    width: parent.width
                    text: root.bubbleText
                    font.family: root.textFamily
                    font.pixelSize: root.bubbleFontSize
                    color: alpha(theme.fg, 0.65)
                    wrapMode: Text.WordWrap
                    maximumLineCount: 3
                    elide: Text.ElideRight
                    lineHeight: 1.4
                }
            }
        }

        Row {
            width: parent.width
            spacing: 3

            CompanionArrow {
                text: "‹"
                anchors.verticalCenter: parent.verticalCenter
                onClicked: root.navigate(-1)
            }

            Item {
                width: root.spriteSize
                height: root.spriteSize
                anchors.verticalCenter: parent.verticalCenter

                AnimatedImage {
                    id: sprite
                    width: root.spriteSize
                    height: root.spriteSize
                    source: root.companions[root.currentIdx].src
                    playing: true
                    smooth: false
                    fillMode: Image.PreserveAspectFit

                    property real reactX: 0
                    property real reactScale: 1.0
                    x: reactX
                    scale: reactScale

                    SequentialAnimation {
                        id: angryAnim
                        NumberAnimation {
                            target: sprite
                            property: "reactX"
                            to: -7
                            duration: 55
                        }
                        NumberAnimation {
                            target: sprite
                            property: "reactX"
                            to: 7
                            duration: 55
                        }
                        NumberAnimation {
                            target: sprite
                            property: "reactX"
                            to: -6
                            duration: 55
                        }
                        NumberAnimation {
                            target: sprite
                            property: "reactX"
                            to: 6
                            duration: 55
                        }
                        NumberAnimation {
                            target: sprite
                            property: "reactX"
                            to: 0
                            duration: 55
                        }
                    }
                    SequentialAnimation {
                        id: loveAnim
                        NumberAnimation {
                            target: sprite
                            property: "reactScale"
                            to: 1.18
                            duration: 120
                            easing.type: Easing.OutQuad
                        }
                        NumberAnimation {
                            target: sprite
                            property: "reactScale"
                            to: 1.05
                            duration: 100
                        }
                        NumberAnimation {
                            target: sprite
                            property: "reactScale"
                            to: 1.0
                            duration: 180
                            easing.type: Easing.InQuad
                        }
                    }
                    SequentialAnimation {
                        id: bounceAnim
                        NumberAnimation {
                            target: sprite
                            property: "reactScale"
                            to: 1.18
                            duration: 200
                            easing.type: Easing.OutQuad
                        }
                        NumberAnimation {
                            target: sprite
                            property: "reactScale"
                            to: 1.0
                            duration: 160
                            easing.type: Easing.InQuad
                        }
                        NumberAnimation {
                            target: sprite
                            property: "reactScale"
                            to: 1.10
                            duration: 130
                        }
                        NumberAnimation {
                            target: sprite
                            property: "reactScale"
                            to: 1.0
                            duration: 110
                        }
                    }
                    SequentialAnimation {
                        id: glowAnim
                        NumberAnimation {
                            target: sprite
                            property: "opacity"
                            to: 0.3
                            duration: 80
                        }
                        NumberAnimation {
                            target: sprite
                            property: "opacity"
                            to: 1.0
                            duration: 130
                        }
                        NumberAnimation {
                            target: sprite
                            property: "opacity"
                            to: 0.5
                            duration: 80
                        }
                        NumberAnimation {
                            target: sprite
                            property: "opacity"
                            to: 1.0
                            duration: 220
                        }
                    }
                    SequentialAnimation {
                        id: spinAnim
                        NumberAnimation {
                            target: sprite
                            property: "reactScale"
                            to: 1.12
                            duration: 100
                        }
                        NumberAnimation {
                            target: sprite
                            property: "reactX"
                            to: 10
                            duration: 100
                        }
                        NumberAnimation {
                            target: sprite
                            property: "reactX"
                            to: -10
                            duration: 140
                        }
                        NumberAnimation {
                            target: sprite
                            property: "reactX"
                            to: 0
                            duration: 110
                        }
                        NumberAnimation {
                            target: sprite
                            property: "reactScale"
                            to: 1.0
                            duration: 100
                        }
                    }
                    NumberAnimation {
                        id: fadeOut
                        target: sprite
                        property: "opacity"
                        to: 0
                        duration: 140
                        easing.type: Easing.InQuad
                        onFinished: {
                            sprite.source = root.companions[root.currentIdx].src;
                            fadeIn.start();
                        }
                    }
                    NumberAnimation {
                        id: fadeIn
                        target: sprite
                        property: "opacity"
                        from: 0
                        to: 1
                        duration: 160
                        easing.type: Easing.OutQuad
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    enabled: !root.isReacting
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.handleClick()
                }
            }

            CompanionArrow {
                text: "›"
                anchors.verticalCenter: parent.verticalCenter
                onClicked: root.navigate(1)
            }
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.companions[root.currentIdx].name
            font.family: root.textFamily
            font.pixelSize: root.nameFontSize
            font.letterSpacing: root.nameLetterSpacing
            color: root.companions[root.currentIdx].color
            Behavior on color {
                ColorAnimation {
                    duration: 150
                }
            }
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 5
            Repeater {
                model: root.companions.length
                Rectangle {
                    width: 5
                    height: 5
                    color: index === root.currentIdx ? theme.fg : alpha(theme.fg, 0.15)
                    Behavior on color {
                        ColorAnimation {
                            duration: 100
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (index !== root.currentIdx)
                                root.setCurrent(index);
                        }
                    }
                }
            }
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 2
            Repeater {
                model: root.spamCount
                Rectangle {
                    width: 9
                    height: 3
                    property int recentCount: {
                        var now = Date.now();
                        var ct = root.clickTimes[root.currentIdx];
                        var cnt = 0;
                        for (var i = 0; i < ct.length; i++) {
                            if (now - ct[i] < root.spamWindow)
                                cnt++;
                        }
                        return cnt;
                    }
                    color: index < recentCount ? (recentCount >= root.spamCount - 1 ? theme.red : theme.gold) : alpha(theme.fg, 0.1)
                    Behavior on color {
                        ColorAnimation {
                            duration: 80
                        }
                    }
                }
            }
        }
    }

    Timer {
        id: bubbleTimer
        onTriggered: root.bubbleVisible = false
    }
    Timer {
        id: reactTimer
        interval: 3500
        onTriggered: root.isReacting = false
    }

    function navigate(dir) {
        setCurrent((currentIdx + dir + companions.length) % companions.length);
    }

    function setCurrent(idx) {
        bubbleVisible = false;
        currentIdx = idx;
        fadeOut.start();
    }

    function handleClick() {
        if (root.isReacting)
            return;
        var now = Date.now();
        var ct = clickTimes[currentIdx].slice();
        ct.push(now);
        ct = ct.filter(function (t) {
            return now - t < spamWindow;
        });
        var ct2 = clickTimes.slice();
        ct2[currentIdx] = ct;
        clickTimes = ct2;

        var cooldownOk = (now - reactCooldown[currentIdx]) > reactCooldownMs;
        if (ct.length >= spamCount && cooldownOk) {
            root.isReacting = true;
            var cd = reactCooldown.slice();
            cd[currentIdx] = now;
            reactCooldown = cd;
            var ct3 = clickTimes.slice();
            ct3[currentIdx] = [];
            clickTimes = ct3;

            var used = reactUsed[currentIdx].slice();
            var reacts = companions[currentIdx].reactions;
            var available = [];
            for (var i = 0; i < reacts.length; i++) {
                if (used.indexOf(i) < 0)
                    available.push(i);
            }
            var pickIdx;
            if (available.length > 0) {
                pickIdx = available[Math.floor(Math.random() * available.length)];
                used.push(pickIdx);
            } else {
                pickIdx = Math.floor(Math.random() * reacts.length);
                used = [];
            }
            var ru = reactUsed.slice();
            ru[currentIdx] = used;
            reactUsed = ru;
            triggerReaction(reacts[pickIdx]);
        } else {
            var li = lineIdxs.slice();
            var line = companions[currentIdx].lines[li[currentIdx] % companions[currentIdx].lines.length];
            li[currentIdx]++;
            lineIdxs = li;
            showBubble(line, false);
        }
    }

    function triggerReaction(r) {
        showBubble(r.text, true);
        sprite.reactX = 0;
        sprite.reactScale = 1.0;
        sprite.opacity = 1.0;
        if (r.type === "angry")
            angryAnim.start();
        else if (r.type === "love")
            loveAnim.start();
        else if (r.type === "bounce")
            bounceAnim.start();
        else if (r.type === "glow")
            glowAnim.start();
        else if (r.type === "spin")
            spinAnim.start();
        reactTimer.restart();
    }

    function showBubble(text, isReaction) {
        bubbleText = text;
        isReactionBubble = isReaction;
        bubbleVisible = true;
        bubbleTimer.interval = isReaction ? 5500 : 4000;
        bubbleTimer.restart();
    }

    function showExternalLine(text) {
        if (!text || text === "")
            return;
        var clean = String(text).replace(/\s+/g, " ").trim();
        if (clean.length > 150)
            clean = clean.substring(0, 147) + "...";

        showBubble(clean, true);
    }

    function resetDialogue() {
        lineIdxs = [0, 0, 0];
        reactUsed = [[], [], []];
        bubbleVisible = false;
        Qt.callLater(function () {
            if (root.companions[root.currentIdx]?.lines?.length > 0) {
                root.showBubble(root.companions[root.currentIdx].lines[0], false);
                var li = root.lineIdxs.slice();
                li[root.currentIdx] = 1;
                root.lineIdxs = li;
            }
        });
    }

    Component.onCompleted: Qt.callLater(function () {
        showBubble(companions[currentIdx].lines[0], false);
        var li = lineIdxs.slice();
        li[currentIdx] = 1;
        lineIdxs = li;
    })
}
