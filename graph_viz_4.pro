QT += gui quick widgets qml

SOURCES += \
    main.cpp \
    ngraphapp.cpp \
    ngraphmodel.cpp \
    ngraphview.cpp \
    NGraph/ngraph.cpp

HEADERS += \
    ngraphapp.h \
    ngraphmodel.h \
    ngraphview.h \
    NGraph/ngraph.h

RESOURCES += \
    resources.qrc

OTHER_FILES += \
    qml/main.qml \
    qml/NGraphEdge.qml \
    qml/NGraphNode.qml \
    qml/NNiftyButton.qml \
    qml/NGraphEdge.qml
