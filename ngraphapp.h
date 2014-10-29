#ifndef NGRAPHAPP_H
#define NGRAPHAPP_H

#include "ngraphmodel.h"
#include "ngraphview.h"
#include <QApplication>

class NGraphApp {

public:
    NGraphApp(int argc, char* argv[]);
    ~NGraphApp();
    int exec();

private:
    QApplication *m_app;
    NGraphModel *m_model;
    NGraphView *m_view;
};

#endif // NGRAPHAPP_H
