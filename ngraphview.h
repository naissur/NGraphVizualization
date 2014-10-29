#ifndef NGRAPHVIEW_H
#define NGRAPHVIEW_H

#include <QObject>
#include <QQuickView>

#define STD_WIDTH 640
#define STD_HEIGHT 480


class NGraphView : public QObject {

    Q_OBJECT
public:
    explicit NGraphView(QObject *parent = 0);
    NGraphView(int width, int height, QObject *parent = 0);
    ~NGraphView();

    void show();

signals:
    void addNodeToModel(double x, double y);
    void moveNodeInModel(double x, double y, QString label);

    // QML signals declared here
    void addNodeToGraphView(QVariant x, QVariant y, QVariant label);
    void moveNodeInGraphView(QVariant x, QVariant y, QVariant label);

public slots:
    void testMove();
    void addNodeToView(double x, double y, QString label);
    void moveNodeInView(double x, double y, QString label);

private:
    QQuickView *m_window;

};

#endif // NGRAPHVIEW_H
