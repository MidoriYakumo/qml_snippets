[MockInputEvent](./main.qml)
============================

This project demostrates how to send input event, including MouseEvent and KeyEvent to any Component via **QtTest**.

To be noticed that on some platform some of the events should be sent asynchronously so a timer/defer is required to perform event sending action.

A virtualkey control created with this idea can be found in: [qml-virtualkey](https://github.com/MidoriYakumo/qml-virtualkey)

![](./main.0.png)
