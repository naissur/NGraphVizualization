#ifndef NGRAPHMODEL_H
#define NGRAPHMODEL_H

#include <QObject>
#include "NGraph/ngraph.h"

class NGraphModel : public QObject {

    Q_OBJECT
public:
    explicit NGraphModel(QObject *parent = 0);
    ~NGraphModel();

signals:
    void addNodeToView(double x, double y, QString label);
    void moveNodeInView(double x, double y, QString label);

public slots:
    void addNodeToModel(double x, double y);
    void moveNodeInModel(double x, double y, QString label);

private:
    NGraph* m_ngraph;

};

#endif // NGRAPHMODEL_H
