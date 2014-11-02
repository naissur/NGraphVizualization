#include "ngraphview.h"
#include <QScreen>
#include <QQuickItem>
//#include <QtMath>
#include <QDebug>
#include <cmath>

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
    connect(graphArea, 	SIGNAL(addEdgeToModel(QString, QString, double, QString)),
            this,		SIGNAL(addEdgeToModel(QString,QString,double,QString)) );

    connect(this, SIGNAL(addEdgeToGraphView(QVariant,QVariant,QVariant,QVariant)),
            graphArea, SLOT(addEdgeToGraphView(QVariant,QVariant,QVariant,QVariant)) );

    connect(graphArea,  SIGNAL(moveNodeInModel(double, double, QString)),
            this,		SIGNAL(moveNodeInModel(double,double,QString)) );

    connect(this, 		SIGNAL(addNodeToGraphView(QVariant,QVariant,QVariant)),
            graphArea,  SLOT(addNodeToGraphView(QVariant, QVariant, QVariant)) );

    connect(this, 		SIGNAL(moveNodeInGraphView(QVariant, QVariant, QVariant)),
            graphArea,  SLOT(moveNodeInGraphView(QVariant, QVariant, QVariant)));

    connect(graphArea, 	SIGNAL(stabilizeGraphModel(double, double)),
            this,		SIGNAL(stabilizeGraphModel(double,double)));

    //connect(this, 		SIGNAL(moveEdgeInGraphView(QVariant,QVariant,QVariant,QVariant,QVariant)),
            //graphArea, 	SLOT(moveEdgeInGraphView(QVariant,QVariant,QVariant,QVariant,QVariant)) );

    qDebug("NGraphView: Created a NGraphView instance");
}

void NGraphView::show(){

    /*int N = 20;
    int n1 = 1;
    emit addNodeToModel(150+100, 150+100);
    for(double a = 0; a < 2*3.14159265358979; a+= 3.14159265358979*2/N){
        n1++;
        emit addNodeToModel((1+cos(a))*150+100, (1+sin(a))*150+100);
        emit addEdgeToModel(QString::number(1),
                            QString::number(n1),
                            a/5+1, QString("Edge ").append(QString::number(1)).
                            append(QString(" ")).append(QString::number(n1)) );
    }*/
    m_window->show();

    /*int N = 20;     // ADD K(N)
    for(double a = 0; a < 2*3.14159265358979; a+= 3.14159265358979*2/N){
        emit addNodeToModel((1+cos(a))*150+100, (1+sin(a))*150+100);
    }

    int n2;
    for(int n1 = 1; n1 <= N; n1++){
        for(n2 = n1+1; n2 <= N; n2++){
            emit addEdgeToModel(QString::number(n1),
                                QString::number(n2),
                                1, QString("Edge ").append(QString::number(n1)).
                                append(QString(" ")).append(QString::number(n2)) );
        }
    }*/

    qDebug("NGraphView: Shown NGraphView view");
}


void NGraphView::addNodeToView(double x, double y, QString label){
    qDebug() << "NGraphView: Added node " << label;
    emit addNodeToGraphView(QVariant(x), QVariant(y), QVariant(label));
}

void NGraphView::moveNodeInView(double x, double y, QString label){
    emit moveNodeInGraphView(QVariant(x), QVariant(y), QVariant(label));
}

void NGraphView::addEdgeToView(QString labelStart, QString labelEnd, QString label, double weight){
    emit addEdgeToGraphView(QVariant(labelStart), QVariant(labelEnd), QVariant(label), QVariant(weight));
}

/*void NGraphView::moveEdgeInView(double x1, double y1, double x2, double y2, QString label){
    emit moveEdgeInGraphView(QVariant(x1), QVariant(y1),
                             QVariant(x2), QVariant(y2), QVariant(label));
}*/

NGraphView::~NGraphView(){
    delete m_window;
}
