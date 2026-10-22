import QtQuick
import QtQuick.Controls

import qs.styles

Slider {
    id: slider

    property color activeColor: Colors.md3.primary
    property color inactiveColor: Colors.md3.surface_container_high
    property real waveAnimationPhase: 1
    property real waveFrequency: 10
    property real waveTransition: 1.0
    property real waveAmplitude: Metrics.spacingXs
    property int separatorWidth: Metrics.spacingS
    property int trackThickness: Metrics.borderThick * 2
    property int handleSize: Metrics.sliderHandleSize
    property bool enableWave: true

    implicitHeight: handleSize + waveAmplitude * 2

    Behavior on waveTransition {
        NumberAnimation {
            duration: Metrics.durationSlow
            easing.bezierCurve: [0.38, 1.21, 0.22, 1, 1, 1]
        }
    }

    snapMode: Slider.NoSnap
    onEnableWaveChanged: waveTransition = enableWave ? 1.0 : 0.0

    NumberAnimation on waveAnimationPhase {
        running: slider.enableWave
        from: 0
        to: Math.PI * 2
        duration: 2000
        loops: Animation.Infinite
    }

    background: Item {
        id: bg

        readonly property real trackStartX: 0
        readonly property real trackEndX: width
        readonly property real trackWidth: trackEndX - trackStartX
        readonly property real normalizedValue: slider.visualPosition

        x: slider.leftPadding
        y: slider.topPadding + slider.availableHeight / 2 - height / 2
        width: slider.availableWidth
        height: slider.height

        Canvas {
            id: wavyCanvas

            anchors.fill: parent
            antialiasing: true
            onPaint: {
                var ctx = getContext("2d");
                ctx.clearRect(0, 0, width, height);
                var trackStartX = bg.trackStartX;
                var trackWidth = bg.trackWidth;
                var normalizedValue = bg.normalizedValue;
                var activeWidth = trackWidth * normalizedValue;
                var gapOffset = slider.separatorWidth / 2;
                activeWidth = Math.max(0, activeWidth - gapOffset);
                ctx.strokeStyle = slider.activeColor;
                ctx.lineWidth = slider.trackThickness;
                ctx.lineCap = "round";
                ctx.lineJoin = "round";
                ctx.beginPath();
                ctx.moveTo(trackStartX, height / 2);

                var steps = Math.max(Math.floor(activeWidth / 3), 30);
                var effectiveAmplitude = slider.waveAmplitude * slider.waveTransition;

                for (var i = 1; i <= steps; i++) {
                    var progress = i / steps;
                    var currentProgress = (progress * activeWidth) / trackWidth;
                    var x = trackStartX + trackWidth * currentProgress;
                    var waveOffset = Math.sin(currentProgress * Math.PI * 2 * slider.waveFrequency + slider.waveAnimationPhase) * effectiveAmplitude;
                    var y = height / 2 + waveOffset;
                    ctx.lineTo(x, y);
                }

                ctx.stroke();
            }
            Connections {
                target: slider

                function onVisualPositionChanged() {
                    wavyCanvas.requestPaint();
                }

                function onWaveAnimationPhaseChanged() {
                    wavyCanvas.requestPaint();
                }

                function onWaveTransitionChanged() {
                    wavyCanvas.requestPaint();
                }

                function onActiveColorChanged() {
                    wavyCanvas.requestPaint();
                }

                function onTrackThicknessChanged() {
                    wavyCanvas.requestPaint();
                }
            }
        }
        Canvas {
            id: inactiveCanvas

            anchors.fill: parent
            antialiasing: true
            onPaint: {
                var ctx = getContext("2d");
                ctx.clearRect(0, 0, width, height);
                var trackStartX = bg.trackStartX;
                var trackWidth = bg.trackWidth;
                var normalizedValue = bg.normalizedValue;
                var gapOffset = slider.separatorWidth / 2;
                var inactiveStartPos = normalizedValue + (gapOffset / trackWidth);
                var inactiveWidth = trackWidth * (1 - inactiveStartPos);
                if (inactiveWidth <= 0 || inactiveStartPos >= 1)
                    return;
                ctx.strokeStyle = slider.inactiveColor;
                ctx.lineWidth = slider.trackThickness;
                ctx.lineCap = "round";
                ctx.lineJoin = "round";
                var startX = trackStartX + trackWidth * inactiveStartPos;
                var startY = height / 2;
                ctx.beginPath();
                ctx.moveTo(startX, startY);
                ctx.lineTo(trackStartX + trackWidth, height / 2);
                ctx.stroke();
            }
            Connections {
                target: slider

                function onVisualPositionChanged() {
                    inactiveCanvas.requestPaint();
                }

                function onInactiveColorChanged() {
                    inactiveCanvas.requestPaint();
                }

                function onTrackThicknessChanged() {
                    inactiveCanvas.requestPaint();
                }
            }
        }
    }

    handle: Rectangle {
        id: handleRect

        x: slider.leftPadding + slider.visualPosition * (slider.availableWidth - width)
        y: slider.topPadding + slider.availableHeight / 2 - height / 2
        width: slider.handleSize
        height: slider.handleSize
        radius: width / 2
        color: slider.activeColor
        opacity: slider.hovered ? 1 : 0
        scale: slider.pressed ? 1.3 : 1

        Behavior on scale {
            NumberAnimation {
                duration: Metrics.durationNormal
                easing.bezierCurve: [0.2, 0, 0, 1, 1, 1]
            }
        }
        Behavior on opacity {
            NumberAnimation {
                duration: Metrics.durationNormal
                easing.bezierCurve: [0.2, 0, 0, 1, 1, 1]
            }
        }
    }
}