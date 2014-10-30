#include "ngraphapp.h"


NGraphApp::NGraphApp(int argc, char* argv[]) {
    qDebug("NGraphApp: Created an NGraphApp instance");
    m_app = new QApplication(argc, argv);
    m_model = new NGraphModel();
    m_view = new NGraphView(800, 480);


    // Connecting Signals to Slots between Model and View \\

    QObject::connect(m_view,  SIGNAL(addNodeToModel(double,double)),
                     m_model, SLOT(addNodeToModel(double,double)));

    QObject::connect(m_model, SIGNAL(addNodeToView(double,double,QString)),
                     m_view,  SLOT(addNodeToView(double,double,QString)));

    QObject::connect(m_model, SIGNAL(addEdgeToView(double,double,double,double,QString,double)),
                     m_view, SLOT(addEdgeToView(double, double, double, double, QString, double)) );

    QObject::connect(m_view,  SIGNAL(moveNodeInModel(double,double,QString)),
                     m_model, SLOT(moveNodeInModel(double,double,QString)) );

    QObject::connect(m_model, SIGNAL(moveNodeInView(double,double,QString)),
                     m_view,  SLOT(moveNodeInView(double,double,QString)) );

    QObject::connect(m_model, SIGNAL(moveEdgeInView(double,double,double,double,QString)),
                     m_view,  SLOT(moveEdgeInView(double,double,double,double,QString)) );

    QObject::connect(m_view,  SIGNAL(addEdgeToModel(QString,QString,double,QString)),
                     m_model, SLOT(addEdgeToModel(QString,QString,double,QString)) );

}

int NGraphApp::exec(){
    qDebug("NGraphApp: Executing NGraphApp...");
    m_model->init();
    m_view->show();

    //m_view->addNodeToModel(100, 100);
    //m_view->addNodeToModel(200, -200);
    return m_app->exec();
}

NGraphApp::~NGraphApp(){
    m_app->exit();
    delete m_model;
    delete m_view;
}
