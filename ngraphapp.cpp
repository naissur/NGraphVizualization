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

    QObject::connect(m_view,  SIGNAL(moveNodeInModel(double,double,QString)),
                     m_model, SLOT(moveNodeInModel(double,double,QString)) );

    QObject::connect(m_model, SIGNAL(moveNodeInView(double,double,QString)),
                     m_view,  SLOT(moveNodeInView(double,double,QString)) );

    m_model->addNodeToModel(0, 0);
    m_model->addNodeToModel(200, 200);
    m_model->addNodeToModel(300, 200);
    m_view->moveNodeInView(100, 300, "1");
}

int NGraphApp::exec(){
    qDebug("NGraphApp: Executing NGraphApp...");
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
