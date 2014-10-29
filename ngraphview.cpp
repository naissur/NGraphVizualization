#include "ngraphview.h"
#include <QScreen>
#include <QQuickItem>

NGraphView::NGraphView(QObject *parent) : QObject(parent){
    NGraphView(STD_WIDTH, STD_HEIGHT, parent);
}

NGraphView::NGraphView(int width, int height, QObject *parent) : QObject(parent) {
    m_window = new QQuickView(QUrl("qrc:/qml/main.qml"));
    m_window->create();
    if(m_window == NULL){
        qDebug("NGraphView: error!");
    }
    m_window->setWidth(width);
    m_window->setHeight(height);
    m_window->setX((m_window->screen()->size().width() - m_window->width())/2);
    m_window->setY((m_window->screen()->size().height() - m_window->height())/2);

    QQuickItem *root = m_window->rootObject();
    QQuickItem *graphArea = (QQuickItem *)root->findChild<QObject *>("graphArea");

    connect(graphArea,  SIGNAL(addNodeToModel(double,double)),
            this, 		SIGNAL(addNodeToModel(double,double)) );

    connect(graphArea,  SIGNAL(moveNodeInModel(double, double, QString)),
            this,		SIGNAL(moveNodeInModel(double,double,QString)) );

    connect(this, 		SIGNAL(addNodeToGraphView(QVariant,QVariant,QVariant)),
            graphArea,  SLOT(addNodeToGraphView(QVariant, QVariant, QVariant)) );

    connect(this, 		SIGNAL(moveNodeInGraphView(QVariant, QVariant, QVariant)),
            graphArea,  SLOT(moveNodeInGraphView(QVariant, QVariant, QVariant)));

    qDebug("NGraphView: Created a NGraphView instance");
}

void NGraphView::show(){
    m_window->show();
    qDebug("NGraphView: Shown NGraphView view");
}


void NGraphView::addNodeToView(double x, double y, QString label){
    qDebug(QString("NGraphView: Added node ").append(label).toStdString().c_str());
    emit addNodeToGraphView(QVariant(x), QVariant(y), QVariant(label));
}

void NGraphView::moveNodeInView(double x, double y, QString label){
    emit moveNodeInGraphView(QVariant(x), QVariant(y), QVariant(label));
}

void NGraphView::testMove(){
    moveNodeInView(300, 300, "1");
}

NGraphView::~NGraphView(){
    delete m_window;
}
